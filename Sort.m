function [sortedResult] = Sort(Result,nLayer)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
r = [];
count = 1;
len = length(Result) ;

for i = 1:length(nLayer)
    for j = (len - nLayer(i) ) + 1:len
        %disp(j)
        r(count) = Result(j);
        count = count + 1 ;
    end  
    len = len - nLayer(i) ;
    %Result(length(Result)-nLayer(i):length(Result)) = [];
end 
sortedResult = r ;
end

