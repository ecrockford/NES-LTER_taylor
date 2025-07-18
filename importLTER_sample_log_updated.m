function [LTERsamplelog, header] = importLTER_sample_log(workbookFile, sheetName, dataLines)
%IMPORTFILE Import data from a spreadsheet
%  LTERSAMPLELOG1 = IMPORTFILE(FILE) reads data from the first worksheet
%  in the Microsoft Excel spreadsheet file named FILE.  Returns the data
%  as a table.
%
%  LTERSAMPLELOG1 = IMPORTFILE(FILE, SHEET) reads from the specified
%  worksheet.
%
%  LTERSAMPLELOG1 = IMPORTFILE(FILE, SHEET, DATALINES) reads from the
%  specified worksheet for the specified row interval(s). Specify
%  DATALINES as a positive scalar integer or a N-by-2 array of positive
%  scalar integers for dis-contiguous row intervals.
%
%  Example:
%  LTERsamplelog1 = importfile("\\sosiknas1\Lab_data\LTER\LTER_sample_log.xls", "Sample_log", [2, 1572]);
%
%  See also READTABLE.
%
% Auto-generated by MATLAB on 17-Dec-2019 16:22:06

%% Input handling

% If no sheet is specified, read first sheet
if nargin == 1 || isempty(sheetName)
    sheetName = 1;
end

% If row start and end points are not specified, define defaults
if nargin <= 2
    dataLines = [2, 5000];
end

%% Setup the Import Options and import the data
opts = spreadsheetImportOptions("NumVariables", 45);

% Specify sheet and range
opts.Sheet = sheetName;
opts.DataRange = "A" + dataLines(1, 1) + ":AS" + dataLines(1, 2);

% Specify column names and types
opts.VariableNames = ["Cruise", "DateUTC", "StartTimeUTC", "StationDepth", "LTERStation", "CastType", "Cast", "Niskin", "NiskinTargetDepth", "ChlVolA", "ChlVolB", "Chl10VolA", "Chl10VolB", "Chl5", "Chl20", "Apvol", "apfilename", "adfilename", "cdomY", "cdomfilename", "HPLC_aHSL", "HPLC_aVol", "HPLC_bHSL", "HPLC_bVol", "DOC","CHN_aID", "CHN_aVol", "CHN_bID", "CHN_bVol", "CHNblank", "Nuta", "Nutb", "Nutc", "Nut_Falcon_tube_a", "Nut_Falcon_tube_b", "FCMFR", "IFCB", "OOIchlaID", "OOIchlbID", "OOInutID", "OOInutbID", "OOIDOID", "OOISaltID", "OOIDICID", "OOIpHID", "VarName42", "Comments", "VarName44", "VarName45"];
opts.VariableTypes = ["categorical", "double", "double", "double", "double", "categorical", "double", "double", "categorical", "double", "categorical", "double", "double", "categorical", "categorical", "double", "categorical", "categorical", "categorical", "categorical", "double", "double", "double", "double", "categorical", "double", "double", "double", "double", "categorical", "double", "double", "double", "double", "double", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "string", "categorical", "string", "string"];

% Specify variable properties
opts = setvaropts(opts, ["VarName42", "VarName44", "VarName45"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Cruise", "CastType", "NiskinTargetDepth", "ChlVolB", "Chl5", "Chl20", "apfilename", "adfilename", "cdomY", "cdomfilename", "DOC", "CHNblank", "FCMFR", "IFCB", "OOIchlaID", "OOIchlbID", "OOInutID", "OOInutbID", "OOIDOID", "OOISaltID", "OOIDICID", "OOIpHID", "VarName42", "Comments", "VarName44", "VarName45"], "EmptyFieldRule", "auto");

% Import the data
LTERsamplelog = readtable(workbookFile, opts, "UseExcel", false);

for idx = 2:size(dataLines, 1)
    opts.DataRange = "A" + dataLines(idx, 1) + ":AS" + dataLines(idx, 2);
    tb = readtable(workbookFile, opts, "UseExcel", false);
    LTERsamplelog = [LTERsamplelog; tb]; %#ok<AGROW>
end
header = ["Cruise", "DateUTC", "StartTimeUTC", "StationDepth", "LTERStation", "CastType", "Cast", "Niskin", "NiskinTargetDepth", "ChlVolA", "ChlVolB", "Chl10VolA", "Chl10VolB", "Chl5", "Chl20", "Apvol", "apfilename", "adfilename", "cdomY", "cdomfilename", "HPLC_aHSL", "HPLC_aVol", "HPLC_bHSL", "HPLC_bVol", "DOC", "CHN_aID", "CHN_aVol", "CHN_bID", "CHN_bVol", "CHNblank", "Nuta", "Nutb", "Nutc", "Nut_Falcon_tube_a", "Nut_Falcon_tube_b", "FCMFR", "IFCB", "OOIchlaID", "OOIchlbID", "OOInutID", "OOInutbID", "OOIDOID", "OOISaltID", "OOIDICID", "OOIpHID", "VarName42", "Comments", "VarName44", "VarName45"];
end