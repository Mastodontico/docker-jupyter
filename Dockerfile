FROM python:3
# Java Kernel
RUN wget -O /tmp/anaconda.sh https://repo.continuum.io/archive/Anaconda3-5.1.0-Linux-x86_64.sh && chmod u+x /tmp/anaconda.sh 
RUN bash /tmp/anaconda.sh -b -p /opt/conda
ENV PATH /opt/conda/bin:$PATH
RUN conda config --add channels conda-forge

RUN conda install -y 'python>=3' nodejs pandas openjdk maven
RUN conda config --env --add pinned_packages 'openjdk>8.0.121'
RUN conda install -y -c conda-forge jupyterlab
RUN conda install -c conda-forge ipywidgets beakerx
RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager

# Jupyter

RUN python3 -m pip install jupyter
RUN python3 -m pip install jupyter_contrib_nbextensions
RUN jupyter contrib nbextension install --system
RUN pip install jupyter_nbextensions_configurator
RUN jupyter nbextensions_configurator enable --system

# to enable extensions right in the image (there's a web configurator, so probably not needed)
# RUN jupyter nbextension enable codefolding/main
RUN pip install psycopg2-binary sqlalchemy
RUN pip install numpy pandas pillow scikit-learn scipy
# install EVERYTHING
RUN pip install keras tensorflow
# python3.6, no CUDA
RUN pip install http://download.pytorch.org/whl/cpu/torch-0.3.1-cp36-cp36m-linux_x86_64.whl 
RUN pip install torchvision
RUN pip install matplotlib

# Spacy language models
RUN pip install spacy
RUN python -m spacy download it
RUN python -m spacy download en
# TODO: conda incasina i pacchetti già installati, da capire in che ordine installare i pacchetti e conda
# sembra che se installo conda e poi uso pip normalmente funziona, ma conda durante l'installazione non migra i pacchetti esistenti
RUN python3 -m pip install jupyter_nbextensions_configurator
CMD jupyter notebook --NotebookApp.token='' --allow-root --port 8000 --ip='0.0.0.0' --notebook-dir /jupyter
