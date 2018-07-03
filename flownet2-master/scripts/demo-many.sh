#! /bin/bash
PYTHONPATH=/media/sunx/Data/linux-workspace/matlab-workspace/drone/flownet2-master/python
python run-flownet-many.py ../models/FlowNet2/FlowNet2_weights.caffemodel.h5 ../models/FlowNet2/FlowNet2_deploy.prototxt.template list.txt
