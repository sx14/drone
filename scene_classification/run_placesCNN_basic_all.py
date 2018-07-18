import argparse
import torch
from torch.autograd import Variable as V
import torchvision.models as models
from torchvision import transforms as trn
from torch.nn import functional as F
import os
from PIL import Image

parser = argparse.ArgumentParser(description='scene classification')
parser.add_argument('--data', metavar='DIR', help='path to dataset')
parser.add_argument('--output', metavar='DIR', help='path to output dir')
parser.add_argument('--step', metavar='N', help='run every N frames')


def main():
    args = parser.parse_args()
    # th architecture to use
    arch = 'resnet18'
    # load the pre-trained weights
    # model_file = '%s_places365.pth.tar' % arch
    model_file = '%s_best.pth.tar' % arch
    if not os.access(model_file, os.W_OK):
        print('model not found')

    # model = models.__dict__[arch](num_classes=365)
    model = models.__dict__[arch](num_classes=4)
    checkpoint = torch.load(model_file, map_location=lambda storage, loc: storage)
    state_dict = {str.replace(k,'module.',''): v for k,v in checkpoint['state_dict'].items()}
    model.load_state_dict(state_dict)
    model.eval()
    # load the image transformer
    centre_crop = trn.Compose([
            trn.Resize((256, 256)),
            trn.CenterCrop(224),
            trn.ToTensor(),
            trn.Normalize([0.485, 0.456, 0.406], [0.229, 0.224, 0.225])
    ])

    # load the class label
    # file_name = 'categories_places365.txt'
    file_name = 'categories_scene4.txt'
    if not os.access(file_name, os.W_OK):
        print('category list not found')
    classes = list()
    with open(file_name) as class_file:
        for line in class_file:
            classes.append(line.strip().split(' ')[0][3:])
    classes = tuple(classes)

    # load the test image
    data_root = args.data
    output_root = args.output
    video_list = os.listdir(data_root)
    step = int(args.step)
    for v in range(0, len(video_list)):
        video_name = video_list[v]
        video_path = os.path.join(data_root, video_name)
        scene_output_file_path = os.path.join(output_root, video_name+'.txt')
        scene_output_file = open(scene_output_file_path, 'w')
        frame_list = os.listdir(video_path)
        for f in range(0, len(frame_list), step):
            frame_name = frame_list[f]
            frame_path = os.path.join(video_path, frame_name)
            img = Image.open(frame_path)
            input_img = V(centre_crop(img).unsqueeze(0))
            # forward pass
            logit = model.forward(input_img)
            h_x = F.softmax(logit).data.squeeze()
            # probs, idx = h_x.sort(0, True)
            # print('{} prediction on {}'.format(arch, input_img))
            # output the prediction
            probabilities = ''
            for i in range(0, 4):
                probabilities = probabilities + '{:.3f} '.format(h_x[i])
            probabilities = probabilities + '\n'
            scene_output_file.write(probabilities)
        scene_output_file.close()

if __name__ == '__main__':
    main()