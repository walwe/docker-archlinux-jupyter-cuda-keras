FROM walwe/archlinux-cuda

RUN useradd -ms /bin/bash jupyter
RUN pacman -Sy --noconfirm \
               jupyter-notebook \
               jupyter-nbconvert \
               jupyter-widgetsnbextension \
               python-ipywidgets \
               mathjax \
               tensorflow-cuda \
               git \
               python \
               python-numpy \
               python-pandas \
               python-psycopg2 \
               python-sqlalchemy \
               python-scikit-learn \
               python-werkzeug \
               python-pip && \
	pacman -Scc --noconfirm

# Ignore dependency to avoid overwriting cuda
RUN pacman -Sy --noconfirm -dd \
	python-matplotlib \
    python-cycler \
	python-protobuf \
	python-tensorflow-cuda && \
	pacman -Scc --noconfirm

RUN pip --no-cache-dir install \
		pycuda \
		keras \
		nbextensions \
		jupyter_nbextensions_configurator \
		jupyter_contrib_nbextensions \
        plotly

RUN pip install git+https://github.com/farizrahman4u/recurrentshop.git && \
    pip install git+https://github.com/farizrahman4u/seq2seq.git

RUN jupyter contrib nbextension install --system
RUN jupyter nbextension enable --py --sys-prefix widgetsnbextension

USER jupyter
WORKDIR /home/jupyter

EXPOSE 8888

ADD start-jupyter.sh /
CMD /start-jupyter.sh
