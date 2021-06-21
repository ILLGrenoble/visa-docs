# visa-docs

This is the main documentation repository for the VISA platform.

This project uses the [sphinx documentation generator](https://www.sphinx-doc.org/en/master/).

The documentation is hosted here: https://visa.readthedocs.io/en/latest/

### Development

**Install sphinx**

```
pip3 install sphinx
```

**Install the python requirements**

```
cd docs
pip3 install -r requirements.txt
```

**Build the documentation**

Inside the project root directory, execute the following commands:

```
cd docs
make html
```

####  Live reload

Rebuild Sphinx documentation on changes, with live-reload in the browser using [sphinx-autobuild](https://pypi.org/project/sphinx-autobuild/).

**Install**

`````pip install sphinx-autobuild
pip3 install sphinx-autobuild
`````

**Launching**

```
cd docs
sphinx-autobuild source _build/html
```

Navigate to http://127.0.0.1:8000/ to see the documentation