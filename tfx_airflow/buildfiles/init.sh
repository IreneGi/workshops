#!/bin/bash
# Copyright 2019 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Set up the environment for the TFX tutorial

GREEN=$(tput setaf 2)
NORMAL=$(tput sgr0)

# Set locale
locale-gen en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US:en
export LC_ALL=en_US.UTF-8

# Add sources for GCC and Python3.6
add-apt-repository -y ppa:ubuntu-toolchain-r/test
add-apt-repository -y ppa:jonathonf/python-3.6
apt-get update

# Fix GCC problem with Airflow
apt-get install -y --no-install-recommends gcc-7 g++-7 \
    && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 60 --slave /usr/bin/g++ g++ /usr/bin/g++-7

# Upgrade to Python 3.6
apt-get install -y --no-install-recommends python3.6 python3.6-dev

# Create virtualenv and activate
cd /root
virtualenv -p python3.6 tfx_env
source /root/tfx_env/bin/activate

# Cleanup, dependencies, installs
pip uninstall setuptools -y && pip install setuptools
pip install -U httplib2==0.12.0
pip install tensorflow==2.0.0
pip install tfx==0.15.0rc0

# Install Jupyter and extensions
ipython kernel install --user --name=tfx
pip install --upgrade notebook==5.7.8
jupyter nbextension install --py --symlink --sys-prefix tensorflow_model_analysis
jupyter nbextension enable --py --sys-prefix tensorflow_model_analysis

pip install matplotlib \
    papermill \
    pandas \
    networkx
export SLUGIFY_USES_TEXT_UNIDECODE=yes
pip install apache-airflow

# Checkout TFX from latest release branch
cd /root
git clone https://github.com/tensorflow/tfx.git
cd tfx

# Patch in new notebooks
cd /root
git clone https://github.com/tensorflow/workshops.git
rm -rf /root/tfx/tfx/examples/airflow_workshop/notebooks
cp -R /root/workshops/tfx_airflow/notebooks /root/tfx/tfx/examples/airflow_workshop
chmod -R 777 /root/tfx/tfx/examples/airflow_workshop/notebooks
