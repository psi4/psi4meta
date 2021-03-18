#!/bin/bash
constructor --platform {{ cookiecutter.platform }} . --conda-exe $CONDA_PREFIX/bin/conda
