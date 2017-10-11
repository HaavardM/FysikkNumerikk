function [ avg ] = vecs2avg( data )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    minLen = numel(data{1}(1, :));
    for i = 2 : numel(data)
        if numel(data{i}(1, :)) < minLen; minLen = numel(data{i}(1, :)); end
    end
    sum = zeros(2, minLen);
    for i = 1 : numel(data)
        sum = sum + data{i}(:, 1:minLen);
    end
    avg = sum/numel(data);
end

