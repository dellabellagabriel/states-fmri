clc
clear
alphabets = [0 1]; % Distinct symbols that data source can produce
p = [.99 .01]; % Probability distribution
n=1024;
x=randsrc(1,n,[alphabets;p]) ;
disp('==================================');
disp('lempel-ziv input sequence is created');
strInput = strrep((mat2str(x)),' ','');
strInput = strrep(strInput,'[','');
strInput =  strrep(strInput,']','');
disp('mat2str completed');
%%
codeBook = cellstr(['0';'1']);
%% lempel-ziv calculation

[value codeBook NumRep NumRepBin ] = lempelzivEnc(strInput,codeBook);

%%

outputLength = length( NumRepBin{1})*length(NumRepBin)-length(NumRepBin);
inputLength = length(strInput);
compRatio = outputLength/inputLength*100;
str = sprintf('========================\nInput length is %d and output length is %d\nCompression ratio is %f',inputLength,outputLength,compRatio);

disp(str);