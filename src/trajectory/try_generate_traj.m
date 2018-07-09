detection_result_root = '/media/sunx/Data/drone_dataset/VisDrone-Dataset/2-Object-Detection-in-Videos/VisDrone2018-VID-train/annotations';
video_root = '/media/sunx/Data/drone_dataset/VisDrone-Dataset/2-Object-Detection-in-Videos/VisDrone2018-VID-train/sequences';
video_name = 'uav0000013_00000_v';
flow_root = fullfile('/home/sunx/output/drone/train/flow', video_name);
detections = read_detection_result(detection_result_root, video_root, video_name);
[trajectories, t_f_mat] = generate_trajectories(detections, flow_root);