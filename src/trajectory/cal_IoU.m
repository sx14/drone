function iou = cal_IoU(box1, box2)
left_max = max(box1(1), box2(1));
right_min = min(box1(1)+box1(3)-1, box2(1)+box2(3)-1);
top_max = max(box1(2), box2(2));
bottom_min = min(box1(2)+box1(4)-1, box2(2)+box2(4)-1);
inter_width = right_min - left_max;
inter_height = bottom_min - top_max;
if inter_width > 0 && inter_height > 0
    inter_area = inter_width * inter_height;
    iou = inter_area / (box1(3)*box1(4) + box2(3)*box2(4) - inter_area);
else
    iou = 0;
end