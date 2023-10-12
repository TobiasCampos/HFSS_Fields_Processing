clear; clc;

FileNames = uigetfile('*.mat','Select the tissue mesh file to open', 'MultiSelect', 'on');
[FileName, PathName] = uigetfile('*.mat','Select meshes','MultiSelect','on');

selpath = uigetdir(path,title);