% detection : cell (frame_sum * 100)
function detections = read_detection_result(detection_root, video_root, video_name)
frames = dir(fullfile(video_root, video_name, '*.jpg'));
raw_detection = load(fullfile(detection_root, [video_name, '.txt']));
detections = cell(length(frames), 100);
frame_next_position = ones(length(frames), 1);
for i = 1: size(raw_detection, 1)
    detection.frame = raw_detection(i, 1);
    detection.oid = raw_detection(i, 2);
    detection.id = -1;
    left = raw_detection(i, 3);
    top = raw_detection(i, 4);
    width = raw_detection(i, 5);
    height = raw_detection(i, 6);
    detection.box = [left, top, width, height];
    detection.score = raw_detection(i, 7);
    detection.class = raw_detection(i, 8);
    detections{detection.frame, frame_next_position(detection.frame)} = detection;
    frame_next_position(detection.frame, 1) = frame_next_position(detection.frame, 1) + 1;
end