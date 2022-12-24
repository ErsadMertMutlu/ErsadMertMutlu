% Erşad Mert Mutlu 
%% Steel 6150 and Aluminum 7075 Datas
clc;
clear;
close all;

%Steel 6150 Datas
S_SpecimenInfo = 99; % HRB
S_SpecimenDiameter = 6.37; % mm
S_MeasurementInterval = 1; % sec
S_CrossheadSpeed = 2; % mm/min 
S_CompensationFactor = 1;
S_FullScaleLoad = 100*10^3; % N
S_FullScaleStrain = 100; % percent
S_StrainAtBreak = 0.2655; % dimensionless
S_Diameter = 4.68; % mm
S_Area = (pi*(S_SpecimenDiameter/2)^2); % mm^2

% Getting Steel 6150 datasets from Excel file
opts = spreadsheetImportOptions("NumVariables", 4);
opts.Sheet = "Sheet1";
opts.DataRange = "A20:D390";
opts.VariableNames = ["S_Position", "S_Load", "S_Strain", "S_Time"];
opts.VariableTypes = ["double", "double", "double", "double"];
tbl1 = readtable("Steel_6150.xlsx", opts, "UseExcel", false);

%Aluminum 7075 Datas
A_CrossheadSpeed = 4; % mm/sec
A_Diameter = 7.16; % mm
A_Hardness = 0;
A_GripDiameter = 12.5; % mm
A_GageLength = 25.4; % mm
Final_Diameter = 6.63*10^-3; % m
A_Area = pi*(A_Diameter/2)^2; % mm^2

% Getting Aluminum 7075 dataset from Excel file
opts = spreadsheetImportOptions("NumVariables", 4);
opts.Sheet = "Specimen_RawData_1 (5)";
opts.DataRange = "A16:D250";
opts.VariableNames = ["A_Time","A_Extension","A_Load","A_Strain"];
opts.VariableTypes = ["double","double","double","double"];
tbl2 = readtable("Aluminum_7075.xlsx",opts,"UseExcel",false);

% Defining all variables 
A_Time = tbl2.A_Time; % s
A_Extension= tbl2.A_Extension; % mm
A_Load = tbl2.A_Load; % N
A_Strain = tbl2.A_Strain; % Unitless
clear opts tbl2
 
S_Position = tbl1.S_Position;
S_Load = tbl1.S_Load.*10^3; % N
S_Strain = tbl1.S_Strain; % Unitless
S_Time = tbl1.S_Time;
clear opts tbl1

%% PART A)

%Calculating and plotting stress-strain graph by using ssgraph function that I created.
S_Stress = (S_Load./S_Area);
ssgraph(S_Strain,S_Stress)
title("Steel 6150 Stress-Strain Diagram")

A_Stress = A_Load./A_Area;
ssgraph(A_Strain,A_Stress)
title("Aluminum 7075 Stress-Strain Diagram")

%% PART B
%Finding Young's Modulus by calling youngmodls function that I created
Steel6150_YM = youngmodls(S_Strain,S_Stress);
Aluminum7075_YM = youngmodls(A_Strain,A_Stress);

%% Part C
%Determining Ultimate Strength and Yield Strength For 0.2% Offset of Steel6150
S_UltimateStrength = max(S_Stress);

S_OffsetStrain = S_Strain+0.002;
S_OffsetStrength = abs(S_Strain.*Steel6150_YM);
figure
plot(S_OffsetStrain(1:100),S_OffsetStrength(1:100),LineWidth=2)
hold on 
plot(S_Strain,S_Stress,LineWidth=2)
hold off
title("Yield Strength of Steel 6150 Where Intersected Point")
legend("Offsett Line","Stress-Strain Curve")
xlabel("Strain (\epsilon)")
ylabel("Stress (MPa)")

%Determining Ultimate Strength and Yield Strength For 0.2% Offset of Aluminum 7075
A_UltimateStrength = max(A_Stress);

A_OffsetStrain = A_Strain+0.002;
A_OffsetStrength = abs(A_Strain.*Aluminum7075_YM);
figure
plot(A_OffsetStrain(1:100),A_OffsetStrength(1:100),LineWidth=2)
hold on 
plot(A_Strain,A_Stress,LineWidth=2)
hold off
title("Yield Strength of Aluminum 7075 Where Intersected Point")
legend("Offsett Line","Stress-Strain Curve")
xlabel("Strain (\epsilon)")
ylabel("Stress (MPa)")

%% Part D
% Calculating True stresses with while loop
i = 1;

while i <= 371
S_TrueStrain(i) = log(1+S_Strain(i))./log(2.71828182845);
S_TrueStress(i) = S_Stress(i)*exp(S_TrueStrain(i));
i = i+1;
end

S_TrueStress = S_TrueStress';
S_TrueStrain = S_TrueStrain';

figure
plot(S_TrueStrain,S_TrueStress,LineWidth=2)
hold on 
plot(S_Strain,S_Stress,LineWidth=2)
xlabel("Strain (\epsilon)")
ylabel("Stress (MPa)")
title("Comparing True Stress-Strain and Engineering Stress-Strain Graph of Steel 6150")
legend("True Stress-Strain","Engineering Stress-Strain")


i = 1;
while i <= 235
A_TrueStrain(i) = log(1+A_Strain(i))./log(2.71828182845);
A_TrueStress(i) = A_Stress(i)*exp(A_TrueStrain(i));
i = i+1;
end

A_TrueStress = A_TrueStress';
A_TrueStrain = A_TrueStrain';

figure
plot(A_TrueStrain,A_TrueStress,LineWidth=2)
hold on 
plot(A_Strain,A_Stress,LineWidth=2)
xlabel("Strain (\epsilon)")
ylabel("Stress (MPa)")
title("Comparing True Stress-Strain and Engineering Stress-Strain Graph of Aluminum 7075")
legend("True Stress-Strain","Engineering Stress-Strain")

%% PART E
% Calculating thoughness and ductility
ToughnessOfSteel = polyarea(S_Strain,S_Stress)*10^6;
ToughnessOfAluminum = polyarea(A_Strain,A_Stress)*10^6;

DuctilityofSteel = max(S_Strain);
DuctilityofAluminum = max(A_Strain);
%% Part F
n_S = (log(S_TrueStress(185))-log(S_TrueStress(182))/(log(S_TrueStrain(185)-log(S_TrueStrain(182)))));
K_S = S_TrueStress(217)/(S_TrueStrain(217)^n_S);

n_A = (log(A_TrueStress(185))-log(A_TrueStress(182))/(log(A_TrueStrain(185)-log(A_TrueStrain(182)))));
K_A = A_TrueStress(217)/(A_TrueStrain(217)^n_A);
%% Functions

function [SSGraph] = ssgraph(Strain,Stress)
w = Strain;
x = Stress;
[TF1,s3,s4] = ischange(w,"linear","MaxNumChanges",5);
EndPoint1 = find(TF1);

figure;
SSGraph = plot(Strain,Stress,LineWidth=2)
xlabel("Strain (\epsilon)")
ylabel("Stress (MPa)")
title("Stress-Strain Graph")
hold on 
plot(w(EndPoint1(1)), x(EndPoint1(1)), '+r')
hold off
grid
text(w(EndPoint1(1)), x(EndPoint1(1)), sprintf('\\leftarrowLinear Region End:\n    Strain =%10.4f\n    Stress  = %10.4f', w(EndPoint1(1)), x(EndPoint1(1))), 'HorizontalAlignment','left', 'VerticalAlignment','top')

end
 
function [YM] = youngmodls(Strain,Stress)
[TF,s1,s2] = ischange(Strain,"linear","MaxNumChanges",5);
Coefficients = polyfit(Strain(1:find(TF)),Stress(1:find(TF)),1); 
px = [min(Strain(1:find(TF))) max(Strain(1:find(TF)))];   
YM = Coefficients(1);
end