%% Import data from spreadsheet
% Script for importing data from the following spreadsheet:
%
%    Workbook: \\sosiknas1\Lab_data\LTER\CHN\data\CHN_BLANKS.xlsx
%    Worksheet: CHN_blanks
%
% Auto-generated by MATLAB on 28-Sep-2022 16:51:49

%% Setup the Import Options and import the data
opts = spreadsheetImportOptions("NumVariables", 8);

% Specify sheet and range
opts.Sheet = "CHN_blanks";
opts.DataRange = "A2:H84";

% Specify column names and types
opts.VariableNames = ["date_combusted", "date_run", "CHN_blank", "replicate", "Var5", "umolN", "umolC", "Notes"];
opts.SelectedVariableNames = ["date_combusted", "date_run", "CHN_blank", "replicate", "umolN", "umolC", "Notes"];
opts.VariableTypes = ["double", "double", "categorical", "categorical", "char", "categorical", "categorical", "categorical"];

% Specify variable properties
opts = setvaropts(opts, "Var5", "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["CHN_blank", "replicate", "Var5", "umolN", "umolC", "Notes"], "EmptyFieldRule", "auto");

% Import the data
CHNBLANKS = readtable("\\sosiknas1\Lab_data\LTER\CHN\data\CHN_BLANKS.xlsx", opts, "UseExcel", false);


%% Clear temporary variables
clear opts