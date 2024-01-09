clc; clear; close all;
format long
dir_path = "E:\VScode\metod_optim\matlab\task12 merged\";                                                      % File's directory
file_names1 = ["BULK_1.txt" "BULK_2.txt" "BULK_3.txt" "BULK_4.txt" "BULK_5.txt"];                           % Names of data files (task 1)
file_names2 = ["BULK_LARGE.txt" "BULK_12.txt" "BULK_22.txt" "BULK_32.txt" "BULK_42.txt" "BULK_52.txt"];     % Names of data files (task 2)

%% Task 1
for i = 1:length(file_names1)
    file_path = strcat(dir_path, file_names1(i));                                                           % Building absolute path to data file
    f = @() opt_task1_fun(file_path);                                                                       % Function handler for estimating run time for each data file [sec]
    t1{i} = timeit(f);                                                                                      % Estimating run time for each data file [sec]
    [Ufact1{i}, Ucalc1{i}, error1{i}] = opt_task1_fun(file_path);                                           % Temperature and error calculation
end
errors1 = cell2mat(error1); % Calculation error for each data file

delete 'console1.txt';
diary ('E:\VScode\metod_optim\matlab\task12 merged\console1.txt')

for i = 1:length(file_names1)
    disp(sprintf('For the file %s', file_names1(i)));
    disp(sprintf('Estimated temperature'));
    disp(sprintf('%3f ',cell2mat(Ucalc1(i))));
    disp(sprintf('Discrepancy %3f ',errors1(i)));
    disp(sprintf('Execution time %3f per second',cell2mat(t1(i))));
    disp(' ');
end
diary off

%% Task 2
for i = 1:length(file_names2)
    file_path = strcat(dir_path, file_names2(i));                                                           % Building absolute path to data file
    f = @() opt_task1_fun(file_path);                                                                       % Function handler for estimating run time for each data file [sec]
    t2{i} = timeit(f);                                                                                      % Estimating run time for each data file [sec]
    [Ufact2{i}, Ucalc2{i}, error2{i}] = opt_task1_fun(file_path);                                           % Temperature and error calculation
end
errors2 = cell2mat(error2);

delete 'console2.txt';
diary ('E:\VScode\metod_optim\matlab\task12 merged\console2.txt')

for i = 1:length(file_names2)
    disp(sprintf('For the file %s', file_names2(i)));
    disp(sprintf('Estimated temperature'));
    disp(sprintf('%3f ',cell2mat(Ucalc2(i))));
    disp(sprintf('Discrepancy %3f ',errors2(i)));
    disp(sprintf('Execution time %3f per second',cell2mat(t2(i))));
    disp(' ');
end
diary off