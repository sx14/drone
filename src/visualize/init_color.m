function color_v = init_color(color_sum)
color_v = [
    255,0,255;  % p
    225,0,0;    % r
    0,255,255;  % q
    0,255,0;    % g 
    255,255,0;  % y 
    0,0,255;    % b
    255,255,255;% w
    128,128,128;
    ];
if color_sum > size(color_v,1)
    color_v = zeros(color_sum,3);
    color_v(:,1) = randperm(color_sum);
    color_v(:,2) = randperm(color_sum);
    color_v(:,3) = randperm(color_sum);
    color_v = mod(color_v,256);
end
