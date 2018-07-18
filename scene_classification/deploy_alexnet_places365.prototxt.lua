require 'cudnn'
local model = {}
-- warning: module 'data [type Data]' not found
table.insert(model, {'conv1', cudnn.SpatialConvolution(3, 96, 11, 11, 4, 4, 0, 0, 1)})
table.insert(model, {'relu1', cudnn.ReLU(true)})
table.insert(model, {'pool1', cudnn.SpatialMaxPooling(3, 3, 2, 2, 0, 0):ceil()})
table.insert(model, {'norm1', cudnn.SpatialCrossMapLRN(5, 0.000100, 0.7500, 1.000000)})
table.insert(model, {'conv2', cudnn.SpatialConvolution(96, 256, 5, 5, 1, 1, 2, 2, 2)})
table.insert(model, {'relu2', cudnn.ReLU(true)})
table.insert(model, {'pool2', cudnn.SpatialMaxPooling(3, 3, 2, 2, 0, 0):ceil()})
table.insert(model, {'norm2', cudnn.SpatialCrossMapLRN(5, 0.000100, 0.7500, 1.000000)})
table.insert(model, {'conv3', cudnn.SpatialConvolution(256, 384, 3, 3, 1, 1, 1, 1, 1)})
table.insert(model, {'relu3', cudnn.ReLU(true)})
table.insert(model, {'conv4', cudnn.SpatialConvolution(384, 384, 3, 3, 1, 1, 1, 1, 2)})
table.insert(model, {'relu4', cudnn.ReLU(true)})
table.insert(model, {'conv5', cudnn.SpatialConvolution(384, 256, 3, 3, 1, 1, 1, 1, 2)})
table.insert(model, {'relu5', cudnn.ReLU(true)})
table.insert(model, {'pool5', cudnn.SpatialMaxPooling(3, 3, 2, 2, 0, 0):ceil()})
table.insert(model, {'torch_view', nn.View(-1):setNumInputDims(3)})
table.insert(model, {'fc6', nn.Linear(9216, 4096)})
table.insert(model, {'relu6', cudnn.ReLU(true)})
table.insert(model, {'drop6', nn.Dropout(0.500000)})
table.insert(model, {'fc7', nn.Linear(4096, 4096)})
table.insert(model, {'relu7', cudnn.ReLU(true)})
table.insert(model, {'drop7', nn.Dropout(0.500000)})
table.insert(model, {'fc8', nn.Linear(4096, 365)})
return model