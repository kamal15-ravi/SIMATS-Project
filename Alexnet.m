% Forward path implementation of SqueezeNet 
clc;
clear;
inputFile = '';     %Sample input image for which we want to extract 
                    %intermediate results. If intermed = 0, this value is
                    %not requried. 
meanFile = '';      %Path to the mean file of the dataset
cmp = 0;            %If cmp == 1, program checks the intermediate results
                    %with the expected results and print the difference. 
                    %If you want to use your own image file, set this to 0 
                    %in the confix.txt file.
fileId = fopen('Config.txt');
if (fileId == -1)
    error('Cannot find config.txt in the current directory');
end
line = fgets(fileId);
while (ischar(line)) 
    tokens = strsplit(line, '=');
    if (line(1) == '#')
        line = fgets(fileId);
        continue;
    end
    switch(strtrim(tokens{1}))
        case 'input_file'
            inputFile = strtrim(tokens{2});
        case 'mean_file'
            meanFile = strtrim(tokens{2});
        case 'cmp'
            cmp = str2double(strtrim(tokens{2}));
    end
    line = fgets(fileId);
end
fclose(fileId);
img = preproc(inputFile, meanFile);
%% Convolution Layer 1
%load('Intermed_Results\1_data.mat');
%img = data;
tic
load('Params\conv1_w.mat');
load('Params\conv1_b.mat');
conv_rslt = conv(img, weights, bias, 7, 2, 0, 1);
conv_rslt = relu(conv_rslt);
load('Intermed_Results\2_conv1.mat');
if (cmp)
    fprintf('Max error in conv1: %f\n', max(abs(data(:) - conv_rslt(:))));
end
%% Pooling Layer 1
pool_rslt = maxpool(conv_rslt, 3, 2);
load('Intermed_Results\3_pool1.mat');
if (cmp)
    fprintf('Max error in maxpool1: %f\n', max(abs(data(:) - pool_rslt(:))));
end
%% Fire Layer 2
load('Params\fire2_squeeze1x1_w.mat');
load('Params\fire2_squeeze1x1_b.mat');
conv_rslt = conv(pool_rslt, weights, bias, 1, 1, 0, 1);
conv_rslt = relu(conv_rslt);
load('Intermed_Results\4_fire2_squeeze1x1.mat');
if (cmp)
    fprintf('Max error in Fire2/SQ1: %f\n', max(abs(data(:) - conv_rslt(:))));
end
load('Params\fire2_expand1x1_w.mat');
load('Params\fire2_expand1x1_b.mat');
conv_rslt_1 = conv(conv_rslt, weights, bias, 1, 1, 0, 1);
conv_rslt_1 = relu(conv_rslt_1);
load('Params\fire2_expand3x3_w.mat');
load('Params\fire2_expand3x3_b.mat');
conv_rslt_2 = conv(conv_rslt, weights, bias, 3, 1, 1, 1);
conv_rslt_2 = relu(conv_rslt_2);
conv_rslt = zeros (55, 55, 128);
conv_rslt (:, :, 1:64) = conv_rslt_1;
conv_rslt (:, :, 65:128) = conv_rslt_2;
load('Intermed_Results\9_fire2_concat.mat')
if (cmp)
    fprintf('Max error in Fire2: %f\n', max(abs(data(:) - conv_rslt(:))));
end
%% Fire Layer 3
load('Params\fire3_squeeze1x1_w.mat');
load('Params\fire3_squeeze1x1_b.mat');
conv_rslt = conv(conv_rslt, weights, bias, 1, 1, 0, 1);
conv_rslt = relu(conv_rslt);
load('Intermed_Results\10_fire3_squeeze1x1.mat');
if (cmp)
    fprintf('Max error in Fire3/SQ1: %f\n', max(abs(data(:) - conv_rslt(:))));
end    
load('Params\fire3_expand1x1_w.mat');
load('Params\fire3_expand1x1_b.mat');
conv_rslt_1 = conv(conv_rslt, weights, bias, 1, 1, 0, 1);
conv_rslt_1 = relu(conv_rslt_1);
load('Params\fire3_expand3x3_w.mat');
load('Params\fire3_expand3x3_b.mat');
conv_rslt_2 = conv(conv_rslt, weights, bias, 3, 1, 1, 1);
conv_rslt_2 = relu(conv_rslt_2);
conv_rslt = zeros (55, 55, 128);
conv_rslt (:, :, 1:64) = conv_rslt_1;
conv_rslt (:, :, 65:128) = conv_rslt_2;
load('Intermed_Results\15_fire3_concat.mat')
if (cmp)
    fprintf('Max error in Fire3: %f\n', max(abs(data(:) - conv_rslt(:))));
end
%% Fire Layer 4
load('Params\fire4_squeeze1x1_w.mat');
load('Params\fire4_squeeze1x1_b.mat');
conv_rslt = conv(conv_rslt, weights, bias, 1, 1, 0, 1);
conv_rslt = relu(conv_rslt);
load('Intermed_Results\16_fire4_squeeze1x1.mat');
if (cmp)
    fprintf('Max error in Fire4/SQ1: %f\n', max(abs(data(:) - conv_rslt(:))));
end    
load('Params\fire4_expand1x1_w.mat');
load('Params\fire4_expand1x1_b.mat');
conv_rslt_1 = conv(conv_rslt, weights, bias, 1, 1, 0, 1);
conv_rslt_1 = relu(conv_rslt_1);
load('Params\fire4_expand3x3_w.mat');
load('Params\fire4_expand3x3_b.mat');
conv_rslt_2 = conv(conv_rslt, weights, bias, 3, 1, 1, 1);
conv_rslt_2 = relu(conv_rslt_2);
conv_rslt = zeros (55, 55, 256);
conv_rslt (:, :, 1:128) = conv_rslt_1;
conv_rslt (:, :, 129:256) = conv_rslt_2;
load('Intermed_Results\21_fire4_concat.mat')
if (cmp)
    fprintf('Max error in Fire4: %f\n', max(abs(data(:) - conv_rslt(:))));
end    

%% Pooling Layer 4
pool_rslt = maxpool(conv_rslt, 3, 2);
load('Intermed_Results\22_pool4.mat');
if (cmp)
    fprintf('Max error in maxpool4: %f\n', max(abs(data(:) - pool_rslt(:))));
end
%% Fire Layer 5
load('Params\fire5_squeeze1x1_w.mat');
load('Params\fire5_squeeze1x1_b.mat');
conv_rslt = conv(pool_rslt, weights, bias, 1, 1, 0, 1);
conv_rslt = relu(conv_rslt);
load('Intermed_Results\23_fire5_squeeze1x1.mat');
if (cmp)
    fprintf('Max error in Fire5/SQ1: %f\n', max(abs(data(:) - conv_rslt(:))));
end    
load('Params\fire5_expand1x1_w.mat');
load('Params\fire5_expand1x1_b.mat');
conv_rslt_1 = conv(conv_rslt, weights, bias, 1, 1, 0, 1);
conv_rslt_1 = relu(conv_rslt_1);
load('Params\fire5_expand3x3_w.mat');
load('Params\fire5_expand3x3_b.mat');
conv_rslt_2 = conv(conv_rslt, weights, bias, 3, 1, 1, 1);
conv_rslt_2 = relu(conv_rslt_2); 
conv_rslt = zeros (27, 27, 256);
conv_rslt (:, :, 1:128) = conv_rslt_1;
conv_rslt (:, :, 129:256) = conv_rslt_2;
load('Intermed_Results\28_fire5_concat.mat')
if (cmp)
    fprintf('Max error in Fire5: %f\n', max(abs(data(:) - conv_rslt(:))));
end
%% Fire Layer 6
load('Params\fire6_squeeze1x1_w.mat');
load('Params\fire6_squeeze1x1_b.mat');
conv_rslt = conv(conv_rslt, weights, bias, 1, 1, 0, 1);
conv_rslt = relu(conv_rslt);
load('Intermed_Results\29_fire6_squeeze1x1.mat');
if (cmp)
    fprintf('Max error in Fire6/SQ1: %f\n', max(abs(data(:) - conv_rslt(:))));
end    
load('Params\fire6_expand1x1_w.mat');
load('Params\fire6_expand1x1_b.mat');
conv_rslt_1 = conv(conv_rslt, weights, bias, 1, 1, 0, 1);
conv_rslt_1 = relu(conv_rslt_1);
load('Params\fire6_expand3x3_w.mat');
load('Params\fire6_expand3x3_b.mat');
conv_rslt_2 = conv(conv_rslt, weights, bias, 3, 1, 1, 1);
conv_rslt_2 = relu(conv_rslt_2);
conv_rslt = zeros (27, 27, 384);
conv_rslt (:, :, 1:192) = conv_rslt_1;
conv_rslt (:, :, 193:384) = conv_rslt_2;
load('Intermed_Results\34_fire6_concat.mat')
if (cmp)
    fprintf('Max error in Fire6: %f\n', max(abs(data(:) - conv_rslt(:))));
end
%% Fire Layer 7
load('Params\fire7_squeeze1x1_w.mat');
load('Params\fire7_squeeze1x1_b.mat');
conv_rslt = conv(conv_rslt, weights, bias, 1, 1, 0, 1);
conv_rslt = relu(conv_rslt);
load('Intermed_Results\35_fire7_squeeze1x1.mat');
if (cmp)
    fprintf('Max error in Fire7/SQ1: %f\n', max(abs(data(:) - conv_rslt(:))));
end    
load('Params\fire7_expand1x1_w.mat');
load('Params\fire7_expand1x1_b.mat');
conv_rslt_1 = conv(conv_rslt, weights, bias, 1, 1, 0, 1);
conv_rslt_1 = relu(conv_rslt_1);
load('Params\fire7_expand3x3_w.mat');
load('Params\fire7_expand3x3_b.mat');
conv_rslt_2 = conv(conv_rslt, weights, bias, 3, 1, 1, 1);
conv_rslt_2 = relu(conv_rslt_2);
conv_rslt = zeros (27, 27, 384);
conv_rslt (:, :, 1:192) = conv_rslt_1;
conv_rslt (:, :, 193:384) = conv_rslt_2;
load('Intermed_Results\40_fire7_concat.mat')
if (cmp)
    fprintf('Max error in Fire7: %f\n', max(abs(data(:) - conv_rslt(:))));
end
%% Fire Layer 8
load('Params\fire8_squeeze1x1_w.mat');
load('Params\fire8_squeeze1x1_b.mat');
conv_rslt = conv(conv_rslt, weights, bias, 1, 1, 0, 1);
conv_rslt = relu(conv_rslt);
load('Intermed_Results\41_fire8_squeeze1x1.mat');
if (cmp)
    fprintf('Max error in Fire8/SQ1: %f\n', max(abs(data(:) - conv_rslt(:))));
end
load('Params\fire8_expand1x1_w.mat');
load('Params\fire8_expand1x1_b.mat');
conv_rslt_1 = conv(conv_rslt, weights, bias, 1, 1, 0, 1);
conv_rslt_1 = relu(conv_rslt_1);
load('Params\fire8_expand3x3_w.mat');
load('Params\fire8_expand3x3_b.mat');
conv_rslt_2 = conv(conv_rslt, weights, bias, 3, 1, 1, 1);
conv_rslt_2 = relu(conv_rslt_2);
conv_rslt = zeros (27, 27, 512);
conv_rslt (:, :, 1:256) = conv_rslt_1;
conv_rslt (:, :, 257:512) = conv_rslt_2;
load('Intermed_Results\46_fire8_concat.mat')
if (cmp)
    fprintf('Max error in Fire8: %f\n', max(abs(data(:) - conv_rslt(:))));
end
%% Pooling Layer 8
pool_rslt = maxpool(conv_rslt, 3, 2);
load('Intermed_Results\47_pool8.mat');
if (cmp)
    fprintf('Max error in maxpool8: %f\n', max(abs(data(:) - pool_rslt(:))));
end
%% Fire Layer 9
load('Params\fire9_squeeze1x1_w.mat');
load('Params\fire9_squeeze1x1_b.mat');
conv_rslt = conv(pool_rslt, weights, bias, 1, 1, 0, 1);
conv_rslt = relu(conv_rslt);
load('Intermed_Results\48_fire9_squeeze1x1.mat');
if (cmp)
    fprintf('Max error in Fire9/SQ1: %f\n', max(abs(data(:) - conv_rslt(:))));
end
load('Params\fire9_expand1x1_w.mat');
load('Params\fire9_expand1x1_b.mat');
conv_rslt_1 = conv(conv_rslt, weights, bias, 1, 1, 0, 1);
conv_rslt_1 = relu(conv_rslt_1);
load('Params\fire9_expand3x3_w.mat');
load('Params\fire9_expand3x3_b.mat');
conv_rslt_2 = conv(conv_rslt, weights, bias, 3, 1, 1, 1);
conv_rslt_2 = relu(conv_rslt_2);
conv_rslt = zeros (13, 13, 512);
conv_rslt (:, :, 1:256) = conv_rslt_1;
conv_rslt (:, :, 257:512) = conv_rslt_2;
load('Intermed_Results\53_fire9_concat.mat')
if (cmp)
    fprintf('Max error in Fire9: %f\n', max(abs(data(:) - conv_rslt(:))));
end

%% Convolution Layer 10
load('Params\conv10_w.mat');
load('Params\conv10_b.mat');
conv_rslt = conv(conv_rslt, weights, bias, 1, 1, 1, 1);
conv_rslt = relu(conv_rslt);
load('Intermed_Results\54_conv10.mat');
fprintf('Max error in conv10: %f\n', max(abs(data(:) - conv_rslt(:))));

%% Average Pooling Layer
pool_rslt = avgpool(conv_rslt, 15, 1);
load('Intermed_Results\55_pool10.mat');
fprintf('Max error in avgpool10: %f\n', max(abs(data(:) - pool_rslt(:))));

%% Softmax
soft_rslt = softmax(pool_rslt);
load('Intermed_Results\56_prob.mat');
fprintf('Max error in softmax: %f\n', max(abs(data(:) - soft_rslt(:))));

toc