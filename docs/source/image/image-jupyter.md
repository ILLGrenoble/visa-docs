(image_jupyter)=
# Integrating JupyterLab

The section describes how JupyterLab has been integrated in to the virtual machine image at the ILL. There are many different ways of installing JupyterLab, however a certain amount of configuration has to conform to VISA requirements to ensure that the link to VISA Jupyter Proxy behaves as expected.

## Installation using a python virtual environment

We use pip to install a specific version of JupyterLab and *labextensions*. We install JuypyterLab under the root directory of `/opt/visa/jupyter`. The following script describes the process:

```bash
#!/bin/bash

echo "Installing JupyterLab..."
JUPYTER_DIR=/opt/visa/jupyter

mkdir -p $JUPYTER_DIR
cd $JUPYTER_DIR || exit
python3 -m venv jupyterlab
source jupyterlab/bin/activate

pip install --upgrade pip

pip install jupyterlab==2.2.9
pip install ipywidgets==7.5.1

# enable interactive matplotlib
jupyter labextension install @jupyter-widgets/jupyterlab-manager
jupyter labextension install jupyter-matplotlib@0.7.4
jupyter nbextension enable --py widgetsnbextension

echo "Finished installing JupyterLab"
```

## Starting the server at boot

There are certain requirements for JupyterLab to be correctly integrated into VISA:

- The Jupyter server needs to start automatically during the boot process

  This ensures that JupyterLab is available for connection automatically via VISA without starting it manually

- Jupyter must run as the same user as the owner of the instance

  The VISA user will therefore have access to their home directory and notebook files as they expect

- The *base_url* of the server must be `/jupyter/{INSTANCE_ID}`

  The VISA Jupyter Proxy forwards requests on a specific URL which must match that of the Juptyer server

- The port of the Jupyter Server must be identical to the [configuration of VISA Jupyter Proxy](deployment_environment_variables_jupyter_proxy_port)

  VISA Jupyter Proxy forwards HTTP requests to the Jupyter Server

When creating the instance, VISA API Server uses [cloud-init](https://cloudinit.readthedocs.io/en/latest/index.html) to pass meta data to the instance including `id` (the ID of the instance) and `owner` (the username of the owner). The script below uses these elements to start JupyterLab in the required way (feel free to modify this script accordingly, but keep in mind that changing the *root_url* will break the link to VISA and changing the user will modify the behaviour of Jupyter). 

```bash
#!/bin/bash

JUPYTER_ENV=/opt/visa/jupyter/jupyterlab

# Get owner and instance_id metadata
OWNER=`cloud-init query ds.meta_data.meta.owner`
INSTANCE_ID=`cloud-init query ds.meta_data.meta.id`

# The jupyter configuration file (you may want a different conf depending on dev or prod environments)
JUPYTER_CONF=/path/to/jupyter-conf.py

# Verify that we get the data from cloud-init
if [ -z "$OWNER" ]; then
    echo "Failed to get OWNER from OpenStack instance metadata"
    exit 1
else
    echo "Got owner \"$OWNER\" from OpenStack instance metadata"
fi

if [ -z "$INSTANCE_ID" ]; then
    echo "Failed to get INSTANCE_ID from OpenStack instance metadata"
    exit 1
else
    echo "Got instance ID $INSTANCE_ID from OpenStack instance metadata"
fi

# Defined the base url of Jupyter (as required by VISA Jupyter Proxy)
BASE_URL=/jupyter/$INSTANCE_ID

# Check that the owner/login exists
if ! id "$OWNER" &>/dev/null; then
    echo "Failed to run JupyerLab: User $OWNER not found"
    exit 1
fi

# Run as the instance owner
su - $OWNER <<EOF

echo "Running JupyterLab as $OWNER using conf file $JUPYTER_CONF with base URL $BASE_URL"

# Run JupyterLab
$JUPYTER_ENV/bin/jupyter lab --config $JUPYTER_CONF --NotebookApp.base_url=$BASE_URL

EOF
```

The following is an example config file for Jupyter:

```python
c.NotebookApp.ip = '0.0.0.0'
c.NotebookApp.open_browser = False
c.NotebookApp.port = 8888
c.NotebookApp.trust_xheaders = True
c.NotebookApp.allow_origin = '*'
c.NotebookApp.disable_check_xsrf = False
c.NotebookApp.token = ''
c.Application.log_level = 'DEBUG'
```

Note that the port here is set to 8888: this is the default value in VISA Jupyter Proxy.

## Integration of conda environments

Jupyter comes with a default Python environment. To be able to perform data analysis we replace this with a conda environment with pre-installed libraries. Conda is a package manager and environment manager that allows you to create and use environments for specific analysis purposes. 

It is also possible for users to add their own conda environments to the VISA JupyterLab installation.

More information about Conda can be found [here](https://docs.conda.io).

### Default data analysis environment

The following script can be added the image build process to create a data anlysis environment using conda:

```bash
#!/bin/bash 

# Assume that conda is already installed
CONDA_INSTALL_DIR=/opt/conda
CONDA_ENVS_DIR=$CONDA_INSTALL_DIR/envs
CONDA_EXE=$CONDA_INSTALL_DIR/bin/conda

# The location where Jupyter is installed 
JUPYTER_DIR=/opt/visa/jupyter

CONDA_ALWAYS_YES="true"

# Proxies here if needed
#HTTP_PROXY=http://my.proxy.host:1234
#HTTPS_PROXY=http://my.proxy.host:1234

echo "Setting up conda environment for data analysis"

source "$CONDA_INSTALL_DIR/etc/profile.d/conda.sh"

# Get the yaml description of the environment
$CONDA_EXE env create -f /tmp/environment_data_analysis.yml --force

echo "Creating ipykernel for data analysis"

# Integrate the conda environment into Jupyter
$CONDA_ENVS_DIR/data-analysis/bin/python -m ipykernel install --prefix=$JUPYTER_DIR/jupyterlab --name 'python3' --display-name 'Data Analysis'
```

The final line replaces the default `python3` environment with the data analysis one.

The script expects the location of conda yaml file to be at `/tmp/environment_data_analysis.yml`. The content of the data analysis environment are as follows:

```yaml
name: data-analysis

channels:
  - anaconda
  - conda-forge
  - defaults
  - rdkit

dependencies:
  - cython=0.29.21
  - pip=20.2.4
  - python=3.6.9
  - rdkit=2020.09.2
  - refnx=0.1.19
  - pip:
    - biopython==1.78
    - h5py==3.1.0
    - iminuit==1.5.4
    - ipykernel==5.3.4
    - ipympl==0.5.8
    - ipython==7.16.1
    - pyqt5==5.15.2
    - lmfit==1.0.1
    - matplotlib==3.1.3
    - numba==0.52.0
    - numexpr==2.7.1
    - numpy==1.19.4
    - pandas==1.1.4
    - PeakUtils==1.3.3
    - Pillow==8.0.1
    - PyYAML==5.3.1
    - qtpy==1.9.0
    - requests==2.25.0
    - scikit-learn==0.23.2
    - scipy==1.5.4
    - seaborn==0.11.0
    - statsmodels==0.12.1
    - sympy==1.7
    - ufit==1.4.4
    - jscatter==1.2.7.2
    - uncertainties==3.1.5
    - attrs==20.3.0
    - periodictable==1.5.3

```

### User environments

Assuming as user has created their own Conda environment in VISA and wishes to integrate this into JupyterLab, there are a couple of commands that they need to perform.

Firstly they you need to install `ìpykernel` from within their activated Conda environment:

```bash
> conda activate my_conda_env
(my_conda_env) > conda install ipykernel
(my_conda_env) > python -m ipykernel install --user --name=my_conda_env
```

More details of this can be found on the [VISA User documentation](https://visa.ill.fr/help/data-analysis/conda) at the ILL.

