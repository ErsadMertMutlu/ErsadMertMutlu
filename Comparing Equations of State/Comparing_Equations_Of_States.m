classdef Comparing_Equations_Of_States < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                       matlab.ui.Figure
        GridLayout                     matlab.ui.container.GridLayout
        LeftPanel                      matlab.ui.container.Panel
        ComparingPressuresButton       matlab.ui.control.Button
        BenedictWebbRubinButton        matlab.ui.control.Button
        ComparingEquationsLabel        matlab.ui.control.Label
        VirialEquationOfStateButton    matlab.ui.control.Button
        IdealEquationOfStateButton     matlab.ui.control.Button
        VanDerWallsButton              matlab.ui.control.Button
        BeattieBridgemanButton         matlab.ui.control.Button
        CenterPanel                    matlab.ui.container.Panel
        UIAxes                         matlab.ui.control.UIAxes
        RightPanel                     matlab.ui.container.Panel
        DeviationsButton               matlab.ui.control.Button
        VirialEquationOfStateButton_2  matlab.ui.control.Button
        BenedictWebbRubinButton_2      matlab.ui.control.Button
        BeattieBridgemanButton_2       matlab.ui.control.Button
        VanDerWallsButton_2            matlab.ui.control.Button
        IdealEquationOfStateButton_2   matlab.ui.control.Button
        DeviationsofEquationsLabel     matlab.ui.control.Label
    end

    % Properties that correspond to apps with auto-reflow
    properties (Access = private)
        onePanelWidth = 576;
        twoPanelWidth = 768;
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: ComparingPressuresButton
        function ComparingPressuresButtonPushed(app, event)
            
cla(app.UIAxes) 
R = 0.2968;
a_VanDerWalls = 0.175;
b_VanDerWalls = 0.00138;
R_u=8.314;           %Beattie-Bridgeman gas constant
M=28.013; %The molar of Nytrogen
a_Beattie_Bridgeman=0.02617; %a value from table 3-4
b_Beattie_Bridgeman=-0.00691; %b value from table 3-4
c_Beattie_Bridgeman=4.20*10^4; %c value from table 3-4
B_0=0.05046; %B_0 value from table 3-4
A_0=136.2315; %A_0 value from table 3-4

A_benedict_web_rubin = 106.73;                   % invented constant 
a_benedict_web_rubin = 2.54;                           % invented constant
b_benedict_web_rubin = 0.002328;                  % invented constant
B_benedict_web_rubin= 0.04074;                % invented constant
c_benedict_web_rubin = 7.379*10^4;                 % invented constant
C_benedict_web_rubin = 8.164*10^5;            % invented constant
alfa_benedict_web_rubin = 1.272*10^-4;            % invented constant
gama_benedict_web_rubin = 0.0053;                  % invented constant

%-----------------------Properties-------------------------
%Temperature (K)
A (:,:,1) = [63.1 80 105;65 85 110;70 90 115;75 95 120;77.3 100 125];
%Pressure About Table (kPa)
A (:,:,2) = [12.5 137 1084.6;17.4 229.1 1467.6;38.6 360.8 1939.3;76.1 541.1 2513;101.3 779.2 3208];
%Specific Volumes During Vapor
A (:,:,3) = [1.48189 0.16375 0.02218;1.09347 0.10148 0.01595;0.52632 0.06611 0.01144;0.28174 0.04476 0.00799;0.21639 0.03120 0.00490];
%Second Coefficient For Virial Equation Of State
A (:,:,4) = [-0.013851 -0.0087193 -0.0052135;-0.013069 -0.0077707 -0.0047714;-0.011285 -0.0069753 -0.0043811;-0.009868 -0.0062992 -0.0040341;-0.0092963 -0.0057181 -0.0037237];
%Third Coefficient For Virial Equation Of State
A (:,:,5) = [-0.000068509 -0.0000079963 0.000035529;-0.000055212 -0.0000029714 0.0000038703;-0.000030605 0.00000005557 0.0000040052;-0.000016389 0.00000187250 0.0000040261;-0.000011879 0.0000029446 0.0000039771];
%Forth Coefficient For Virial Equation Of State
A (:,:,6) = [0.000003799 0.00000026334 0.000000015385;0.000002719 0.00000013729 0.0000000094137;0.0000011631 0.000000075278 0.0000000057506;0.00000053551 0.000000043049 0.0000000034419;0.00000037989 0.000000025442 0.0000000019565];
Properties = reshape(A,[15,6]);
%------------------------While Loop------------------------
i = 1;
while i<=15
%------------Taking Properties From 3D Matrix--------------

T = Properties(i,1,1);                    %K
RealPressure = Properties(i,2,1);         %kPa
Specific_Volume = Properties(i,3,1);      %m^3/kg
Second_Coefficient = Properties(i,4,1);
Third_Coefficient = Properties(i,5,1);
Forth_Coefficient = Properties(i,6,1);

%------------------Ideal Gas Equation----------------------

P_Ideal_Gas_Equation = ((R*T)/Specific_Volume);

%----------------Van Der Walls Equation--------------------

P_van_der_walls = (R*T/(Specific_Volume-b_VanDerWalls))-(a_VanDerWalls/Specific_Volume^2);

%--------------------Beattie Bridgeman---------------------

A=A_0*(1-(a_Beattie_Bridgeman/(M*Specific_Volume)));
B=B_0*(1-(b_Beattie_Bridgeman/(M*Specific_Volume)));
P_Beattie_Bridgeman = (((R_u*T)/(M*Specific_Volume)^2)*(1-(c_Beattie_Bridgeman/(M*Specific_Volume*T^3)))*(M*Specific_Volume+B))-(A/(M*Specific_Volume)^2);

%-------------------Benedict Webb Rubin--------------------
        
P_Benedict_Web_Rubin= ((R_u*T)/(M*Specific_Volume)) + (B_benedict_web_rubin*R_u*T - A_benedict_web_rubin - C_benedict_web_rubin/T^2)*(1/(M*Specific_Volume)^2) + ((b_benedict_web_rubin*R_u*T - a_benedict_web_rubin)/(M*Specific_Volume)^3) + ((a_benedict_web_rubin*alfa_benedict_web_rubin)/(M*Specific_Volume)^6) + (c_benedict_web_rubin/((M*Specific_Volume)^3*T^2))*(1+(gama_benedict_web_rubin/(M*Specific_Volume)^2))*10^(-gama_benedict_web_rubin/(M*Specific_Volume)^2);


%-----------------Virial Equation Of State-----------------

P_Virial_Equation_State = (R*T/Specific_Volume)*(1+(Second_Coefficient/Specific_Volume)+(Third_Coefficient/Specific_Volume^2)+(Forth_Coefficient/Specific_Volume^3));

%------To exit from while loop, we need to increase i------
i=i+1;
%-----------------Adding Equations to Arrays---------------
x_Ideal_Gas_Equation(i-1)=[P_Ideal_Gas_Equation];
x_van_der_walls(i-1)=[P_van_der_walls];
x_Beattie_Bridgeman(i-1)=[P_Beattie_Bridgeman];
x_Virial_Equation_State(i-1)=[P_Virial_Equation_State];
x_P_Benedict_Web_Rubin(i-1)=[P_Benedict_Web_Rubin];
%------Adding the Temperature and Pressure to 2D Array-----
t(i-1)=[T];
z(i-1)=[RealPressure];
v(i-1)=[Specific_Volume];
end
plot(app.UIAxes,t,x_Ideal_Gas_Equation,'LineWidth',2,'Color','b')
hold(app.UIAxes,'on');
plot(app.UIAxes,t,x_van_der_walls,'LineWidth',2,'Color','r')
hold(app.UIAxes,'on');
plot(app.UIAxes,t,x_Beattie_Bridgeman,'LineWidth',2,'Color','y')
hold(app.UIAxes,'on');
plot(app.UIAxes,t,x_Virial_Equation_State,'LineWidth',2,'Color','m')
hold(app.UIAxes,'on');
plot(app.UIAxes,t,x_P_Benedict_Web_Rubin,'LineWidth',2,'Color','c')
hold(app.UIAxes,'on');
plot(app.UIAxes,t,z,'LineWidth',2,'Color','g')
xlabel(app.UIAxes,'Temperature')
ylabel(app.UIAxes,'Pressure')
legend(app.UIAxes,'Pressure For Ideal Gas Equation','Pressure For Van Der Walls Equation','Pressure For Beatie Bridgeman','Pressure For Virial Equation of State','Pressure for Benedict Web Rubin Equation','Pressure About Table','FontSize',13)
title(app.UIAxes,'Comparing Equations')
 
        end

        % Button pushed function: DeviationsButton
        function DeviationsButtonPushed(app, event)
          
           cla(app.UIAxes) 
R = 0.2968;
a_VanDerWalls = 0.175;
b_VanDerWalls = 0.00138;
R_u=8.314;           %Beattie-Bridgeman gas constant
M=28.013; %The molar of Nytrogen
a_Beattie_Bridgeman=0.02617; %a value from table 3-4
b_Beattie_Bridgeman=-0.00691; %b value from table 3-4
c_Beattie_Bridgeman=4.20*10^4; %c value from table 3-4
B_0=0.05046; %B_0 value from table 3-4
A_0=136.2315; %A_0 value from table 3-4

A_benedict_web_rubin = 106.73;                   % invented constant 
a_benedict_web_rubin = 2.54;                           % invented constant
b_benedict_web_rubin = 0.002328;                  % invented constant
B_benedict_web_rubin= 0.04074;                % invented constant
c_benedict_web_rubin = 7.379*10^4;                 % invented constant
C_benedict_web_rubin = 8.164*10^5;            % invented constant
alfa_benedict_web_rubin = 1.272*10^-4;            % invented constant
gama_benedict_web_rubin = 0.0053;                  % invented constant
%-----------------------Properties-------------------------
%Temperature (K)
A (:,:,1) = [63.1 80 105;65 85 110;70 90 115;75 95 120;77.3 100 125];
%Pressure About Table (kPa)
A (:,:,2) = [12.5 137 1084.6;17.4 229.1 1467.6;38.6 360.8 1939.3;76.1 541.1 2513;101.3 779.2 3208];
%Specific Volumes During Vapor
A (:,:,3) = [1.48189 0.16375 0.02218;1.09347 0.10148 0.01595;0.52632 0.06611 0.01144;0.28174 0.04476 0.00799;0.21639 0.03120 0.00490];
%Second Coefficient For Virial Equation Of State
A (:,:,4) = [-0.013851 -0.0087193 -0.0052135;-0.013069 -0.0077707 -0.0047714;-0.011285 -0.0069753 -0.0043811;-0.009868 -0.0062992 -0.0040341;-0.0092963 -0.0057181 -0.0037237];
%Third Coefficient For Virial Equation Of State
A (:,:,5) = [-0.000068509 -0.0000079963 0.000035529;-0.000055212 -0.0000029714 0.0000038703;-0.000030605 0.00000005557 0.0000040052;-0.000016389 0.00000187250 0.0000040261;-0.000011879 0.0000029446 0.0000039771];
%Forth Coefficient For Virial Equation Of State
A (:,:,6) = [0.000003799 0.00000026334 0.000000015385;0.000002719 0.00000013729 0.0000000094137;0.0000011631 0.000000075278 0.0000000057506;0.00000053551 0.000000043049 0.0000000034419;0.00000037989 0.000000025442 0.0000000019565];
Properties = reshape(A,[15,6]);
%------------------------While Loop------------------------
i = 1;
while i<=15
%------------Taking Properties From 3D Matrix--------------

T = Properties(i,1,1);                    %K
RealPressure = Properties(i,2,1);         %kPa
Specific_Volume = Properties(i,3,1);      %m^3/kg
Second_Coefficient = Properties(i,4,1);
Third_Coefficient = Properties(i,5,1);
Forth_Coefficient = Properties(i,6,1);

%------------------Ideal Gas Equation----------------------

P_Ideal_Gas_Equation = ((R*T)/Specific_Volume);

%----------------Van Der Walls Equation--------------------

P_van_der_walls = (R*T/(Specific_Volume-b_VanDerWalls))-(a_VanDerWalls/Specific_Volume^2);

%--------------------Beattie Bridgeman---------------------

A=A_0*(1-(a_Beattie_Bridgeman/(M*Specific_Volume)));
B=B_0*(1-(b_Beattie_Bridgeman/(M*Specific_Volume)));
P_Beattie_Bridgeman = (((R_u*T)/(M*Specific_Volume)^2)*(1-(c_Beattie_Bridgeman/(M*Specific_Volume*T^3)))*(M*Specific_Volume+B))-(A/(M*Specific_Volume)^2);

%-------------------Benedict Webb Rubin--------------------
        
P_Benedict_Web_Rubin= ((R_u*T)/(M*Specific_Volume)) + (B_benedict_web_rubin*R_u*T - A_benedict_web_rubin - C_benedict_web_rubin/T^2)*(1/(M*Specific_Volume)^2) + ((b_benedict_web_rubin*R_u*T - a_benedict_web_rubin)/(M*Specific_Volume)^3) + ((a_benedict_web_rubin*alfa_benedict_web_rubin)/(M*Specific_Volume)^6) + (c_benedict_web_rubin/((M*Specific_Volume)^3*T^2))*(1+(gama_benedict_web_rubin/(M*Specific_Volume)^2))*10^(-gama_benedict_web_rubin/(M*Specific_Volume)^2);



%-----------------Virial Equation Of State-----------------

P_Virial_Equation_State = (R*T/Specific_Volume)*(1+(Second_Coefficient/Specific_Volume)+(Third_Coefficient/Specific_Volume^2)+(Forth_Coefficient/Specific_Volume^3));

%------To exit from while loop, we need to increase i------
i=i+1;
%-----------------Adding Equations to Arrays---------------
x_Ideal_Gas_Equation(i-1)=[P_Ideal_Gas_Equation];
x_van_der_walls(i-1)=[P_van_der_walls];
x_Beattie_Bridgeman(i-1)=[P_Beattie_Bridgeman];
x_Virial_Equation_State(i-1)=[P_Virial_Equation_State];
x_P_Benedict_Web_Rubin(i-1)=[P_Benedict_Web_Rubin];
%------Adding the Temperature and Pressure to 2D Array-----
t(i-1)=[T];
z(i-1)=[RealPressure];
v(i-1)=[Specific_Volume];
end
%-------------------Deviation Calculating------------------
j = 1;
while j<=15
    DeviationOfIdealGasEquation=(x_Ideal_Gas_Equation(j)-Properties(j,2,1))/Properties(j,2,1)*100;
    DeviationOfVanDerWallsEquation=(x_van_der_walls(j)-Properties(j,2,1))/Properties(j,2,1)*100;
    DeviationOfBeattieBridgemanEquation=(x_Beattie_Bridgeman(j)-Properties(j,2,1))/Properties(j,2,1)*100;
    DeviationOfVirialEquationOfState=(x_Virial_Equation_State(j)-Properties(j,2,1))/Properties(j,2,1)*100;
    DeviationOfBenedictWebRubin=(x_P_Benedict_Web_Rubin(j)-Properties(j,2,1))/Properties(j,2,1)*100;
    j = j+1;
    DeviationArrayOfIDE (j-1)=[DeviationOfIdealGasEquation];
    DeviationArrayOfVDWE (j-1)=[DeviationOfVanDerWallsEquation];
    DeviationArrayBBE (j-1)=[DeviationOfBeattieBridgemanEquation];
    DeviationArrayVEOS (j-1)=[DeviationOfVirialEquationOfState];
    DeviationArrayBWR(j-1)=[DeviationOfBenedictWebRubin];
    
end
%---------------Plotting Deviation-P Graph------------------
yline(app.UIAxes,0,'LineWidth',2,'Color','g')
hold(app.UIAxes,'on');
plot(app.UIAxes,z,DeviationArrayOfIDE,'LineWidth',2,'Color','b')
hold(app.UIAxes,'on');
plot(app.UIAxes,z,DeviationArrayOfVDWE,'LineWidth',2,'Color','r')
hold(app.UIAxes,'on');
plot(app.UIAxes,z,DeviationArrayBBE,'LineWidth',2,'Color','y')
hold(app.UIAxes,'on');
plot(app.UIAxes,z,DeviationArrayVEOS,'LineWidth',2,'Color','m')
hold(app.UIAxes,'on');
plot(app.UIAxes,z,DeviationArrayBWR,'LineWidth',2,'Color','c')
legend(app.UIAxes,'Perfect Deviation','Deviation Of Ideal Gas Equation','Deviation Of Van Der Walls Equation','Deviation Of Beatie Bridgeman','Deviation Of Virial Equation of State','Deviation Of Benedict Web Rubin Equation','FontSize',13)
title(app.UIAxes,'Deviation')
xlabel(app.UIAxes,'Pressure')
ylabel(app.UIAxes,'Deviation As Percentage')

        end

        % Button pushed function: VirialEquationOfStateButton
        function VirialEquationOfStateButtonPushed(app, event)
           
            cla(app.UIAxes)
R = 0.2968;
%-----------------------Properties-------------------------
%Temperature (K)
A (:,:,1) = [63.1 80 105;65 85 110;70 90 115;75 95 120;77.3 100 125];
%Pressure About Table (kPa)
A (:,:,2) = [12.5 137 1084.6;17.4 229.1 1467.6;38.6 360.8 1939.3;76.1 541.1 2513;101.3 779.2 3208];
%Specific Volumes During Vapor
A (:,:,3) = [1.48189 0.16375 0.02218;1.09347 0.10148 0.01595;0.52632 0.06611 0.01144;0.28174 0.04476 0.00799;0.21639 0.03120 0.00490];
%Second Coefficient For Virial Equation Of State
A (:,:,4) = [-0.013851 -0.0087193 -0.0052135;-0.013069 -0.0077707 -0.0047714;-0.011285 -0.0069753 -0.0043811;-0.009868 -0.0062992 -0.0040341;-0.0092963 -0.0057181 -0.0037237];
%Third Coefficient For Virial Equation Of State
A (:,:,5) = [-0.000068509 -0.0000079963 0.000035529;-0.000055212 -0.0000029714 0.0000038703;-0.000030605 0.00000005557 0.0000040052;-0.000016389 0.00000187250 0.0000040261;-0.000011879 0.0000029446 0.0000039771];
%Forth Coefficient For Virial Equation Of State
A (:,:,6) = [0.000003799 0.00000026334 0.000000015385;0.000002719 0.00000013729 0.0000000094137;0.0000011631 0.000000075278 0.0000000057506;0.00000053551 0.000000043049 0.0000000034419;0.00000037989 0.000000025442 0.0000000019565];
Properties = reshape(A,[15,6]);
%------------------------While Loop------------------------
i = 1;
while i<=15
%------------Taking Properties From 3D Matrix--------------

T = Properties(i,1,1);                    %K
RealPressure = Properties(i,2,1);         %kPa
Specific_Volume = Properties(i,3,1);      %m^3/kg
Second_Coefficient = Properties(i,4,1);
Third_Coefficient = Properties(i,5,1);
Forth_Coefficient = Properties(i,6,1);
%-----------------Virial Equation Of State-----------------

P_Virial_Equation_State = (R*T/Specific_Volume)*(1+(Second_Coefficient/Specific_Volume)+(Third_Coefficient/Specific_Volume^2)+(Forth_Coefficient/Specific_Volume^3));

%------To exit from while loop, we need to increase i------
i=i+1;
%-----------------Adding Equations to Arrays---------------
x_Virial_Equation_State(i-1)=[P_Virial_Equation_State];
%------Adding the Temperature and Pressure to 2D Array-----
t(i-1)=[T];
z(i-1)=[RealPressure];
v(i-1)=[Specific_Volume];
end
plot(app.UIAxes,t,x_Virial_Equation_State,'LineWidth',2,'Color','m')
hold(app.UIAxes, 'on') 
plot(app.UIAxes,t,z,'LineWidth',2,'Color','g')
xlabel(app.UIAxes,'Temperature')
ylabel(app.UIAxes,'Pressure')
legend(app.UIAxes,'Pressure For Virial Equation of State','Pressure About Table','FontSize',13)
title(app.UIAxes,'Comparing Equation Against to Pressure Where In Table')
        end

        % Button pushed function: IdealEquationOfStateButton
        function IdealEquationOfStateButtonPushed(app, event)
           
                        cla(app.UIAxes)
R = 0.2968;
%-----------------------Properties-------------------------
%Temperature (K)
A (:,:,1) = [63.1 80 105;65 85 110;70 90 115;75 95 120;77.3 100 125];
%Pressure About Table (kPa)
A (:,:,2) = [12.5 137 1084.6;17.4 229.1 1467.6;38.6 360.8 1939.3;76.1 541.1 2513;101.3 779.2 3208];
%Specific Volumes During Vapor
A (:,:,3) = [1.48189 0.16375 0.02218;1.09347 0.10148 0.01595;0.52632 0.06611 0.01144;0.28174 0.04476 0.00799;0.21639 0.03120 0.00490];
%Second Coefficient For Virial Equation Of State
A (:,:,4) = [-0.013851 -0.0087193 -0.0052135;-0.013069 -0.0077707 -0.0047714;-0.011285 -0.0069753 -0.0043811;-0.009868 -0.0062992 -0.0040341;-0.0092963 -0.0057181 -0.0037237];
%Third Coefficient For Virial Equation Of State
A (:,:,5) = [-0.000068509 -0.0000079963 0.000035529;-0.000055212 -0.0000029714 0.0000038703;-0.000030605 0.00000005557 0.0000040052;-0.000016389 0.00000187250 0.0000040261;-0.000011879 0.0000029446 0.0000039771];
%Forth Coefficient For Virial Equation Of State
A (:,:,6) = [0.000003799 0.00000026334 0.000000015385;0.000002719 0.00000013729 0.0000000094137;0.0000011631 0.000000075278 0.0000000057506;0.00000053551 0.000000043049 0.0000000034419;0.00000037989 0.000000025442 0.0000000019565];
Properties = reshape(A,[15,6]);
%------------------------While Loop------------------------
i = 1;
while i<=15
%------------Taking Properties From 3D Matrix--------------

T = Properties(i,1,1);                    %K
RealPressure = Properties(i,2,1);         %kPa
Specific_Volume = Properties(i,3,1);      %m^3/kg
Second_Coefficient = Properties(i,4,1);
Third_Coefficient = Properties(i,5,1);
Forth_Coefficient = Properties(i,6,1);
%------------------Ideal Gas Equation----------------------

P_Ideal_Gas_Equation = ((R*T)/Specific_Volume);


%------To exit from while loop, we need to increase i------
i=i+1;
%-----------------Adding Equations to Arrays---------------
x_Ideal_Gas_Equation(i-1)=[P_Ideal_Gas_Equation];
%------Adding the Temperature and Pressure to 2D Array-----
t(i-1)=[T];
z(i-1)=[RealPressure];
v(i-1)=[Specific_Volume];
end
plot(app.UIAxes,t,x_Ideal_Gas_Equation,'LineWidth',2,'Color','b')
hold(app.UIAxes, 'on') 
plot(app.UIAxes,t,z,'LineWidth',2,'Color','g')
xlabel(app.UIAxes,'Temperature')
ylabel(app.UIAxes,'Pressure')
legend(app.UIAxes,'Pressure For Ideal Equation Of State','Pressure About Table','FontSize',13)
title(app.UIAxes,'Comparing Equation Against to Pressure Where In Table')
        end

        % Button pushed function: VanDerWallsButton
        function VanDerWallsButtonPushed(app, event)
            
                                    cla(app.UIAxes)
R = 0.2968;
a_VanDerWalls = 0.175;
b_VanDerWalls = 0.00138;
R_u=8.314;           %Beattie-Bridgeman gas constant
M=28.013; %The molar of Nytrogen
a_Beattie_Bridgeman=0.02617; %a value from table 3-4
b_Beattie_Bridgeman=-0.00691; %b value from table 3-4
c_Beattie_Bridgeman=4.20*10^4; %c value from table 3-4
B_0=0.05046; %B_0 value from table 3-4
A_0=136.2315; %A_0 value from table 3-4
%-----------------------Properties-------------------------
%Temperature (K)
A (:,:,1) = [63.1 80 105;65 85 110;70 90 115;75 95 120;77.3 100 125];
%Pressure About Table (kPa)
A (:,:,2) = [12.5 137 1084.6;17.4 229.1 1467.6;38.6 360.8 1939.3;76.1 541.1 2513;101.3 779.2 3208];
%Specific Volumes During Vapor
A (:,:,3) = [1.48189 0.16375 0.02218;1.09347 0.10148 0.01595;0.52632 0.06611 0.01144;0.28174 0.04476 0.00799;0.21639 0.03120 0.00490];
%Second Coefficient For Virial Equation Of State
A (:,:,4) = [-0.013851 -0.0087193 -0.0052135;-0.013069 -0.0077707 -0.0047714;-0.011285 -0.0069753 -0.0043811;-0.009868 -0.0062992 -0.0040341;-0.0092963 -0.0057181 -0.0037237];
%Third Coefficient For Virial Equation Of State
A (:,:,5) = [-0.000068509 -0.0000079963 0.000035529;-0.000055212 -0.0000029714 0.0000038703;-0.000030605 0.00000005557 0.0000040052;-0.000016389 0.00000187250 0.0000040261;-0.000011879 0.0000029446 0.0000039771];
%Forth Coefficient For Virial Equation Of State
A (:,:,6) = [0.000003799 0.00000026334 0.000000015385;0.000002719 0.00000013729 0.0000000094137;0.0000011631 0.000000075278 0.0000000057506;0.00000053551 0.000000043049 0.0000000034419;0.00000037989 0.000000025442 0.0000000019565];
Properties = reshape(A,[15,6]);
%------------------------While Loop------------------------
i = 1;
while i<=15
%------------Taking Properties From 3D Matrix--------------

T = Properties(i,1,1);                    %K
RealPressure = Properties(i,2,1);         %kPa
Specific_Volume = Properties(i,3,1);      %m^3/kg
Second_Coefficient = Properties(i,4,1);
Third_Coefficient = Properties(i,5,1);
Forth_Coefficient = Properties(i,6,1);
%----------------Van Der Walls Equation--------------------

P_van_der_walls = (R*T/(Specific_Volume-b_VanDerWalls))-(a_VanDerWalls/Specific_Volume^2);

%------To exit from while loop, we need to increase i------
i=i+1;
%-----------------Adding Equations to Arrays---------------
x_van_der_walls(i-1)=[P_van_der_walls];
%------Adding the Temperature and Pressure to 2D Array-----
t(i-1)=[T];
z(i-1)=[RealPressure];
v(i-1)=[Specific_Volume];
end
plot(app.UIAxes,t,x_van_der_walls,'LineWidth',2,'Color','r')
hold(app.UIAxes, 'on') 
plot(app.UIAxes,t,z,'LineWidth',2,'Color','g')
xlabel(app.UIAxes,'Temperature')
ylabel(app.UIAxes,'Pressure')
legend(app.UIAxes,'Pressure For Van Der Walls','Pressure About Table','FontSize',13)
title(app.UIAxes,'Comparing Equation Against to Pressure Where In Table')
        end

        % Button pushed function: BeattieBridgemanButton
        function BeattieBridgemanButtonPushed(app, event)
           
            cla(app.UIAxes)
            R = 0.2968;
a_VanDerWalls = 0.175;
b_VanDerWalls = 0.00138;
R_u=8.314;           %Beattie-Bridgeman gas constant
M=28.013; %The molar of Nytrogen
a_Beattie_Bridgeman=0.02617; %a value from table 3-4
b_Beattie_Bridgeman=-0.00691; %b value from table 3-4
c_Beattie_Bridgeman=4.20*10^4; %c value from table 3-4
B_0=0.05046; %B_0 value from table 3-4
A_0=136.2315; %A_0 value from table 3-4
%-----------------------Properties-------------------------
%Temperature (K)
A (:,:,1) = [63.1 80 105;65 85 110;70 90 115;75 95 120;77.3 100 125];
%Pressure About Table (kPa)
A (:,:,2) = [12.5 137 1084.6;17.4 229.1 1467.6;38.6 360.8 1939.3;76.1 541.1 2513;101.3 779.2 3208];
%Specific Volumes During Vapor
A (:,:,3) = [1.48189 0.16375 0.02218;1.09347 0.10148 0.01595;0.52632 0.06611 0.01144;0.28174 0.04476 0.00799;0.21639 0.03120 0.00490];
%Second Coefficient For Virial Equation Of State
A (:,:,4) = [-0.013851 -0.0087193 -0.0052135;-0.013069 -0.0077707 -0.0047714;-0.011285 -0.0069753 -0.0043811;-0.009868 -0.0062992 -0.0040341;-0.0092963 -0.0057181 -0.0037237];
%Third Coefficient For Virial Equation Of State
A (:,:,5) = [-0.000068509 -0.0000079963 0.000035529;-0.000055212 -0.0000029714 0.0000038703;-0.000030605 0.00000005557 0.0000040052;-0.000016389 0.00000187250 0.0000040261;-0.000011879 0.0000029446 0.0000039771];
%Forth Coefficient For Virial Equation Of State
A (:,:,6) = [0.000003799 0.00000026334 0.000000015385;0.000002719 0.00000013729 0.0000000094137;0.0000011631 0.000000075278 0.0000000057506;0.00000053551 0.000000043049 0.0000000034419;0.00000037989 0.000000025442 0.0000000019565];
Properties = reshape(A,[15,6]);
%------------------------While Loop------------------------
i = 1;
while i<=15
%------------Taking Properties From 3D Matrix--------------

T = Properties(i,1,1);                    %K
RealPressure = Properties(i,2,1);         %kPa
Specific_Volume = Properties(i,3,1);      %m^3/kg
Second_Coefficient = Properties(i,4,1);
Third_Coefficient = Properties(i,5,1);
Forth_Coefficient = Properties(i,6,1);
%----------------Beattie Bridgeman--------------------

A=A_0*(1-(a_Beattie_Bridgeman/(M*Specific_Volume)));
B=B_0*(1-(b_Beattie_Bridgeman/(M*Specific_Volume)));
P_Beattie_Bridgeman = (((R_u*T)/(M*Specific_Volume)^2)*(1-(c_Beattie_Bridgeman/(M*Specific_Volume*T^3)))*(M*Specific_Volume+B))-(A/(M*Specific_Volume)^2);

%------To exit from while loop, we need to increase i------
i=i+1;
%-----------------Adding Equations to Arrays---------------
x_Beattie_Bridgeman(i-1)=[P_Beattie_Bridgeman];
%------Adding the Temperature and Pressure to 2D Array-----
t(i-1)=[T];
z(i-1)=[RealPressure];
v(i-1)=[Specific_Volume];
end
plot(app.UIAxes,t,x_Beattie_Bridgeman,'LineWidth',2,'Color','r')
hold(app.UIAxes, 'on') 
plot(app.UIAxes,t,z,'LineWidth',2,'Color','g')
xlabel(app.UIAxes,'Temperature')
ylabel(app.UIAxes,'Pressure')
legend(app.UIAxes,'Pressure For Beattie Bridgeman','Pressure About Table','FontSize',13)
title(app.UIAxes,'Comparing Equation Against to Pressure Where In Table')
        end

        % Callback function
        function UIFigureSizeChanged(app, event)
    
   
        end

        % Changes arrangement of the app based on UIFigure width
        function updateAppLayout(app, event)
            currentFigureWidth = app.UIFigure.Position(3);
            if(currentFigureWidth <= app.onePanelWidth)
                % Change to a 3x1 grid
                app.GridLayout.RowHeight = {723, 723, 723};
                app.GridLayout.ColumnWidth = {'1x'};
                app.CenterPanel.Layout.Row = 1;
                app.CenterPanel.Layout.Column = 1;
                app.LeftPanel.Layout.Row = 2;
                app.LeftPanel.Layout.Column = 1;
                app.RightPanel.Layout.Row = 3;
                app.RightPanel.Layout.Column = 1;
            elseif (currentFigureWidth > app.onePanelWidth && currentFigureWidth <= app.twoPanelWidth)
                % Change to a 2x2 grid
                app.GridLayout.RowHeight = {723, 723};
                app.GridLayout.ColumnWidth = {'1x', '1x'};
                app.CenterPanel.Layout.Row = 1;
                app.CenterPanel.Layout.Column = [1,2];
                app.LeftPanel.Layout.Row = 2;
                app.LeftPanel.Layout.Column = 1;
                app.RightPanel.Layout.Row = 2;
                app.RightPanel.Layout.Column = 2;
            else
                % Change to a 1x3 grid
                app.GridLayout.RowHeight = {'1x'};
                app.GridLayout.ColumnWidth = {294, '1x', 294};
                app.LeftPanel.Layout.Row = 1;
                app.LeftPanel.Layout.Column = 1;
                app.CenterPanel.Layout.Row = 1;
                app.CenterPanel.Layout.Column = 2;
                app.RightPanel.Layout.Row = 1;
                app.RightPanel.Layout.Column = 3;
            end
        end

        % Button pushed function: IdealEquationOfStateButton_2
        function IdealEquationOfStateButton_2Pushed(app, event)
            cla(app.UIAxes)
            R = 0.2968;
a_VanDerWalls = 0.175;
b_VanDerWalls = 0.00138;
R_u=8.314;           %Beattie-Bridgeman gas constant
M=28.013; %The molar of Nytrogen
a_Beattie_Bridgeman=0.02617; %a value from table 3-4
b_Beattie_Bridgeman=-0.00691; %b value from table 3-4
c_Beattie_Bridgeman=4.20*10^4; %c value from table 3-4
B_0=0.05046; %B_0 value from table 3-4
A_0=136.2315; %A_0 value from table 3-4
%-----------------------Properties-------------------------
%Temperature (K)
A (:,:,1) = [63.1 80 105;65 85 110;70 90 115;75 95 120;77.3 100 125];
%Pressure About Table (kPa)
A (:,:,2) = [12.5 137 1084.6;17.4 229.1 1467.6;38.6 360.8 1939.3;76.1 541.1 2513;101.3 779.2 3208];
%Specific Volumes During Vapor
A (:,:,3) = [1.48189 0.16375 0.02218;1.09347 0.10148 0.01595;0.52632 0.06611 0.01144;0.28174 0.04476 0.00799;0.21639 0.03120 0.00490];
%Second Coefficient For Virial Equation Of State
A (:,:,4) = [-0.013851 -0.0087193 -0.0052135;-0.013069 -0.0077707 -0.0047714;-0.011285 -0.0069753 -0.0043811;-0.009868 -0.0062992 -0.0040341;-0.0092963 -0.0057181 -0.0037237];
%Third Coefficient For Virial Equation Of State
A (:,:,5) = [-0.000068509 -0.0000079963 0.000035529;-0.000055212 -0.0000029714 0.0000038703;-0.000030605 0.00000005557 0.0000040052;-0.000016389 0.00000187250 0.0000040261;-0.000011879 0.0000029446 0.0000039771];
%Forth Coefficient For Virial Equation Of State
A (:,:,6) = [0.000003799 0.00000026334 0.000000015385;0.000002719 0.00000013729 0.0000000094137;0.0000011631 0.000000075278 0.0000000057506;0.00000053551 0.000000043049 0.0000000034419;0.00000037989 0.000000025442 0.0000000019565];
Properties = reshape(A,[15,6]);
%------------------------While Loop------------------------
i = 1;
while i<=15
%------------Taking Properties From 3D Matrix--------------

T = Properties(i,1,1);                    %K
RealPressure = Properties(i,2,1);         %kPa
Specific_Volume = Properties(i,3,1);      %m^3/kg
Second_Coefficient = Properties(i,4,1);
Third_Coefficient = Properties(i,5,1);
Forth_Coefficient = Properties(i,6,1);
%------------------Ideal Gas Equation----------------------

P_Ideal_Gas_Equation = ((R*T)/Specific_Volume);
%------To exit from while loop, we need to increase i------
i=i+1;
%-----------------Adding Equations to Arrays---------------
x_Ideal_Gas_Equation(i-1)=[P_Ideal_Gas_Equation];
%------Adding the Temperature and Pressure to 2D Array-----
t(i-1)=[T];
z(i-1)=[RealPressure];
v(i-1)=[Specific_Volume];
end
%-------------------Deviation Calculating------------------
j = 1;
while j<=15
    DeviationOfIdealGasEquation=(x_Ideal_Gas_Equation(j)-Properties(j,2,1))/Properties(j,2,1)*100;
    j = j+1;
    DeviationArrayOfIDE (j-1)=[DeviationOfIdealGasEquation];
    
end
%---------------Plotting Deviation-P Graph------------------
yline(app.UIAxes,0,'LineWidth',2,'Color','g')
hold(app.UIAxes, 'on')
plot(app.UIAxes,DeviationArrayOfIDE,z,'LineWidth',2,'Color','b')
legend(app.UIAxes,'Perfect Deviation','Deviation Of Ideal Gas Equation','FontSize',13)
title(app.UIAxes,'Deviation Table')
xlabel(app.UIAxes,'Deviation As Percentage')
ylabel(app.UIAxes,'Pressure')
        end

        % Button pushed function: VirialEquationOfStateButton_2
        function VirialEquationOfStateButton_2Pushed(app, event)
            cla(app.UIAxes)
           
R = 0.2968;
a_VanDerWalls = 0.175;
b_VanDerWalls = 0.00138;
R_u=8.314;           %Beattie-Bridgeman gas constant
M=28.013; %The molar of Nytrogen
a_Beattie_Bridgeman=0.02617; %a value from table 3-4
b_Beattie_Bridgeman=-0.00691; %b value from table 3-4
c_Beattie_Bridgeman=4.20*10^4; %c value from table 3-4
B_0=0.05046; %B_0 value from table 3-4
A_0=136.2315; %A_0 value from table 3-4
%-----------------------Properties-------------------------
%Temperature (K)
A (:,:,1) = [63.1 80 105;65 85 110;70 90 115;75 95 120;77.3 100 125];
%Pressure About Table (kPa)
A (:,:,2) = [12.5 137 1084.6;17.4 229.1 1467.6;38.6 360.8 1939.3;76.1 541.1 2513;101.3 779.2 3208];
%Specific Volumes During Vapor
A (:,:,3) = [1.48189 0.16375 0.02218;1.09347 0.10148 0.01595;0.52632 0.06611 0.01144;0.28174 0.04476 0.00799;0.21639 0.03120 0.00490];
%Second Coefficient For Virial Equation Of State
A (:,:,4) = [-0.013851 -0.0087193 -0.0052135;-0.013069 -0.0077707 -0.0047714;-0.011285 -0.0069753 -0.0043811;-0.009868 -0.0062992 -0.0040341;-0.0092963 -0.0057181 -0.0037237];
%Third Coefficient For Virial Equation Of State
A (:,:,5) = [-0.000068509 -0.0000079963 0.000035529;-0.000055212 -0.0000029714 0.0000038703;-0.000030605 0.00000005557 0.0000040052;-0.000016389 0.00000187250 0.0000040261;-0.000011879 0.0000029446 0.0000039771];
%Forth Coefficient For Virial Equation Of State
A (:,:,6) = [0.000003799 0.00000026334 0.000000015385;0.000002719 0.00000013729 0.0000000094137;0.0000011631 0.000000075278 0.0000000057506;0.00000053551 0.000000043049 0.0000000034419;0.00000037989 0.000000025442 0.0000000019565];
Properties = reshape(A,[15,6]);
%------------------------While Loop------------------------
i = 1;
while i<=15
%------------Taking Properties From 3D Matrix--------------

T = Properties(i,1,1);                    %K
RealPressure = Properties(i,2,1);         %kPa
Specific_Volume = Properties(i,3,1);      %m^3/kg
Second_Coefficient = Properties(i,4,1);
Third_Coefficient = Properties(i,5,1);
Forth_Coefficient = Properties(i,6,1);
%-----------------Virial Equation Of State-----------------

P_Virial_Equation_State = (R*T/Specific_Volume)*(1+(Second_Coefficient/Specific_Volume)+(Third_Coefficient/Specific_Volume^2)+(Forth_Coefficient/Specific_Volume^3));

%------To exit from while loop, we need to increase i------
i=i+1;
%-----------------Adding Equations to Arrays---------------
x_Virial_Equation_State(i-1)=[P_Virial_Equation_State];
%------Adding the Temperature and Pressure to 2D Array-----
t(i-1)=[T];
z(i-1)=[RealPressure];
v(i-1)=[Specific_Volume];
end
%-------------------Deviation Calculating------------------
j = 1;
while j<=15
    
    DeviationOfVirialEquationOfState=(x_Virial_Equation_State(j)-Properties(j,2,1))/Properties(j,2,1)*100;
    j = j+1;
    DeviationArrayVEOS (j-1)=[DeviationOfVirialEquationOfState];
    
end
%---------------Plotting Deviation-P Graph------------------
yline(app.UIAxes,0,'LineWidth',2,'Color','g')
hold(app.UIAxes,"on")
plot(app.UIAxes,z,DeviationArrayVEOS,'LineWidth',2,'Color','m')
legend(app.UIAxes,'Perfect Deviation','Deviation Of Virial Equation of State','FontSize',13)
title(app.UIAxes,'Deviation')
xlabel(app.UIAxes,'Deviation As Percentage')
ylabel(app.UIAxes,'Pressure')
        end

        % Button pushed function: VanDerWallsButton_2
        function VanDerWallsButton_2Pushed(app, event)
           cla(app.UIAxes) 
R = 0.2968;
a_VanDerWalls = 0.175;
b_VanDerWalls = 0.00138;
R_u=8.314;           %Beattie-Bridgeman gas constant
M=28.013; %The molar of Nytrogen
a_Beattie_Bridgeman=0.02617; %a value from table 3-4
b_Beattie_Bridgeman=-0.00691; %b value from table 3-4
c_Beattie_Bridgeman=4.20*10^4; %c value from table 3-4
B_0=0.05046; %B_0 value from table 3-4
A_0=136.2315; %A_0 value from table 3-4
%-----------------------Properties-------------------------
%Temperature (K)
A (:,:,1) = [63.1 80 105;65 85 110;70 90 115;75 95 120;77.3 100 125];
%Pressure About Table (kPa)
A (:,:,2) = [12.5 137 1084.6;17.4 229.1 1467.6;38.6 360.8 1939.3;76.1 541.1 2513;101.3 779.2 3208];
%Specific Volumes During Vapor
A (:,:,3) = [1.48189 0.16375 0.02218;1.09347 0.10148 0.01595;0.52632 0.06611 0.01144;0.28174 0.04476 0.00799;0.21639 0.03120 0.00490];
%Second Coefficient For Virial Equation Of State
A (:,:,4) = [-0.013851 -0.0087193 -0.0052135;-0.013069 -0.0077707 -0.0047714;-0.011285 -0.0069753 -0.0043811;-0.009868 -0.0062992 -0.0040341;-0.0092963 -0.0057181 -0.0037237];
%Third Coefficient For Virial Equation Of State
A (:,:,5) = [-0.000068509 -0.0000079963 0.000035529;-0.000055212 -0.0000029714 0.0000038703;-0.000030605 0.00000005557 0.0000040052;-0.000016389 0.00000187250 0.0000040261;-0.000011879 0.0000029446 0.0000039771];
%Forth Coefficient For Virial Equation Of State
A (:,:,6) = [0.000003799 0.00000026334 0.000000015385;0.000002719 0.00000013729 0.0000000094137;0.0000011631 0.000000075278 0.0000000057506;0.00000053551 0.000000043049 0.0000000034419;0.00000037989 0.000000025442 0.0000000019565];
Properties = reshape(A,[15,6]);
%------------------------While Loop------------------------
i = 1;
while i<=15
%------------Taking Properties From 3D Matrix--------------

T = Properties(i,1,1);                    %K
RealPressure = Properties(i,2,1);         %kPa
Specific_Volume = Properties(i,3,1);      %m^3/kg
Second_Coefficient = Properties(i,4,1);
Third_Coefficient = Properties(i,5,1);
Forth_Coefficient = Properties(i,6,1);

%----------------Van Der Walls Equation--------------------

P_van_der_walls = (R*T/(Specific_Volume-b_VanDerWalls))-(a_VanDerWalls/Specific_Volume^2);

%------To exit from while loop, we need to increase i------
i=i+1;
%-----------------Adding Equations to Arrays---------------
x_van_der_walls(i-1)=[P_van_der_walls];

%------Adding the Temperature and Pressure to 2D Array-----
t(i-1)=[T];
z(i-1)=[RealPressure];
v(i-1)=[Specific_Volume];
end
%-------------------Deviation Calculating------------------
j = 1;
while j<=15
    
    DeviationOfVanDerWallsEquation=(x_van_der_walls(j)-Properties(j,2,1))/Properties(j,2,1)*100;
    
    j = j+1;
    
    DeviationArrayOfVDWE (j-1)=[DeviationOfVanDerWallsEquation];
    
    
end
%---------------Plotting Deviation-P Graph------------------
yline(app.UIAxes,0,'LineWidth',2,'Color','g')
hold(app.UIAxes,"on")
plot(app.UIAxes,z,DeviationArrayOfVDWE,'LineWidth',2,'Color','r')
legend(app.UIAxes,'Perfect Deviation','Deviation Of Van Der Walls Equation','FontSize',13)
title(app.UIAxes,'Deviation')
xlabel(app.UIAxes,'Pressure')
ylabel(app.UIAxes,'Deviation As Percentage')
        end

        % Button pushed function: BeattieBridgemanButton_2
        function BeattieBridgemanButton_2Pushed(app, event)
            cla(app.UIAxes) 
R = 0.2968;
a_VanDerWalls = 0.175;
b_VanDerWalls = 0.00138;
R_u=8.314;           %Beattie-Bridgeman gas constant
M=28.013; %The molar of Nytrogen
a_Beattie_Bridgeman=0.02617; %a value from table 3-4
b_Beattie_Bridgeman=-0.00691; %b value from table 3-4
c_Beattie_Bridgeman=4.20*10^4; %c value from table 3-4
B_0=0.05046; %B_0 value from table 3-4
A_0=136.2315; %A_0 value from table 3-4
%-----------------------Properties-------------------------
%Temperature (K)
A (:,:,1) = [63.1 80 105;65 85 110;70 90 115;75 95 120;77.3 100 125];
%Pressure About Table (kPa)
A (:,:,2) = [12.5 137 1084.6;17.4 229.1 1467.6;38.6 360.8 1939.3;76.1 541.1 2513;101.3 779.2 3208];
%Specific Volumes During Vapor
A (:,:,3) = [1.48189 0.16375 0.02218;1.09347 0.10148 0.01595;0.52632 0.06611 0.01144;0.28174 0.04476 0.00799;0.21639 0.03120 0.00490];
%Second Coefficient For Virial Equation Of State
A (:,:,4) = [-0.013851 -0.0087193 -0.0052135;-0.013069 -0.0077707 -0.0047714;-0.011285 -0.0069753 -0.0043811;-0.009868 -0.0062992 -0.0040341;-0.0092963 -0.0057181 -0.0037237];
%Third Coefficient For Virial Equation Of State
A (:,:,5) = [-0.000068509 -0.0000079963 0.000035529;-0.000055212 -0.0000029714 0.0000038703;-0.000030605 0.00000005557 0.0000040052;-0.000016389 0.00000187250 0.0000040261;-0.000011879 0.0000029446 0.0000039771];
%Forth Coefficient For Virial Equation Of State
A (:,:,6) = [0.000003799 0.00000026334 0.000000015385;0.000002719 0.00000013729 0.0000000094137;0.0000011631 0.000000075278 0.0000000057506;0.00000053551 0.000000043049 0.0000000034419;0.00000037989 0.000000025442 0.0000000019565];
Properties = reshape(A,[15,6]);
%------------------------While Loop------------------------
i = 1;
while i<=15
%------------Taking Properties From 3D Matrix--------------

T = Properties(i,1,1);                    %K
RealPressure = Properties(i,2,1);         %kPa
Specific_Volume = Properties(i,3,1);      %m^3/kg
Second_Coefficient = Properties(i,4,1);
Third_Coefficient = Properties(i,5,1);
Forth_Coefficient = Properties(i,6,1);

%--------------------Beattie Bridgeman---------------------

A=A_0*(1-(a_Beattie_Bridgeman/(M*Specific_Volume)));
B=B_0*(1-(b_Beattie_Bridgeman/(M*Specific_Volume)));
P_Beattie_Bridgeman = (((R_u*T)/(M*Specific_Volume)^2)*(1-(c_Beattie_Bridgeman/(M*Specific_Volume*T^3)))*(M*Specific_Volume+B))-(A/(M*Specific_Volume)^2);

%------To exit from while loop, we need to increase i------
i=i+1;
%-----------------Adding Equations to Arrays---------------

x_Beattie_Bridgeman(i-1)=[P_Beattie_Bridgeman];

%------Adding the Temperature and Pressure to 2D Array-----
t(i-1)=[T];
z(i-1)=[RealPressure];
v(i-1)=[Specific_Volume];
end
%-------------------Deviation Calculating------------------
j = 1;
while j<=15
   
    DeviationOfBeattieBridgemanEquation=(x_Beattie_Bridgeman(j)-Properties(j,2,1))/Properties(j,2,1)*100;
    j = j+1;
    DeviationArrayBBE (j-1)=[DeviationOfBeattieBridgemanEquation];
    
    
end
%---------------Plotting Deviation-P Graph------------------
yline(app.UIAxes,0,'LineWidth',2,'Color','g')
hold(app.UIAxes,"on")
plot(app.UIAxes,z,DeviationArrayBBE,'LineWidth',2,'Color','y')
legend(app.UIAxes,'Perfect Deviation','Deviation Of Beatie Bridgeman','FontSize',13)
title(app.UIAxes,'Deviation')
xlabel(app.UIAxes,'Pressure')
ylabel(app.UIAxes,'Deviation As Percentage')
        end

        % Button pushed function: BenedictWebbRubinButton
        function BenedictWebbRubinButtonPushed(app, event)
            cla(app.UIAxes)
R = 0.2968;
a_VanDerWalls = 0.175;
b_VanDerWalls = 0.00138;
R_u=8.314;           %Beattie-Bridgeman gas constant
M=28.013; %The molar of Nytrogen
a_Beattie_Bridgeman=0.02617; %a value from table 3-4
b_Beattie_Bridgeman=-0.00691; %b value from table 3-4
c_Beattie_Bridgeman=4.20*10^4; %c value from table 3-4
B_0=0.05046; %B_0 value from table 3-4
A_0=136.2315; %A_0 value from table 3-4

A_benedict_web_rubin = 106.73                   % invented constant 
a_benedict_web_rubin = 2.54                           % invented constant
b_benedict_web_rubin = 0.002328                  % invented constant
B_benedict_web_rubin= 0.04074                % invented constant
c_benedict_web_rubin = 7.379*10^4                 % invented constant
C_benedict_web_rubin = 8.164*10^5            % invented constant
alfa_benedict_web_rubin = 1.272*10^-4            % invented constant
gama_benedict_web_rubin = 0.0053                  % invented constant





%-----------------------Properties-------------------------
%Temperature (K)
A (:,:,1) = [63.1 80 105;65 85 110;70 90 115;75 95 120;77.3 100 125];
%Pressure About Table (kPa)
A (:,:,2) = [12.5 137 1084.6;17.4 229.1 1467.6;38.6 360.8 1939.3;76.1 541.1 2513;101.3 779.2 3208];
%Specific Volumes During Vapor
A (:,:,3) = [1.48189 0.16375 0.02218;1.09347 0.10148 0.01595;0.52632 0.06611 0.01144;0.28174 0.04476 0.00799;0.21639 0.03120 0.00490];
%Second Coefficient For Virial Equation Of State
A (:,:,4) = [-0.013851 -0.0087193 -0.0052135;-0.013069 -0.0077707 -0.0047714;-0.011285 -0.0069753 -0.0043811;-0.009868 -0.0062992 -0.0040341;-0.0092963 -0.0057181 -0.0037237];
%Third Coefficient For Virial Equation Of State
A (:,:,5) = [-0.000068509 -0.0000079963 0.000035529;-0.000055212 -0.0000029714 0.0000038703;-0.000030605 0.00000005557 0.0000040052;-0.000016389 0.00000187250 0.0000040261;-0.000011879 0.0000029446 0.0000039771];
%Forth Coefficient For Virial Equation Of State
A (:,:,6) = [0.000003799 0.00000026334 0.000000015385;0.000002719 0.00000013729 0.0000000094137;0.0000011631 0.000000075278 0.0000000057506;0.00000053551 0.000000043049 0.0000000034419;0.00000037989 0.000000025442 0.0000000019565];
Properties = reshape(A,[15,6]);
%------------------------While Loop------------------------
i = 1;
while i<=15
%------------Taking Properties From 3D Matrix--------------

T = Properties(i,1,1);                    %K
RealPressure = Properties(i,2,1);         %kPa
Specific_Volume = Properties(i,3,1);      %m^3/kg

%-------------------Benedict Webb Rubin--------------------
        
P_Benedict_Web_Rubin= ((R_u*T)/(M*Specific_Volume)) + (B_benedict_web_rubin*R_u*T - A_benedict_web_rubin - C_benedict_web_rubin/T^2)*(1/(M*Specific_Volume)^2) + ((b_benedict_web_rubin*R_u*T - a_benedict_web_rubin)/(M*Specific_Volume)^3) + ((a_benedict_web_rubin*alfa_benedict_web_rubin)/(M*Specific_Volume)^6) + (c_benedict_web_rubin/((M*Specific_Volume)^3*T^2))*(1+(gama_benedict_web_rubin/(M*Specific_Volume)^2))*10^(-gama_benedict_web_rubin/(M*Specific_Volume)^2);

%------To exit from while loop, we need to increase i------
i=i+1;
%-----------------Adding Equations to Arrays---------------
x_P_Benedict_Web_Rubin(i-1)=[P_Benedict_Web_Rubin]
%------Adding the Temperature and Pressure to 2D Array-----
t(i-1)=[T];
z(i-1)=[RealPressure];
v(i-1)=[Specific_Volume];
end
%-------------------Deviation Calculating------------------
j = 1;
while j<=15
    
    DeviationOfBenedictWebRubin=(x_P_Benedict_Web_Rubin(j)-Properties(j,2,1))/Properties(j,2,1)*100;
    j = j+1;
    DeviationArrayBWR(j-1)=[DeviationOfBenedictWebRubin];
end
%-------------------Plotting P-T Graph------------------
plot(app.UIAxes,t,x_P_Benedict_Web_Rubin,'LineWidth',2,'Color','c')
hold(app.UIAxes,"on")
plot(app.UIAxes,t,z,'LineWidth',2,'Color','g')
xlabel(app.UIAxes,'Temperature')
ylabel(app.UIAxes,'Pressure')
legend(app.UIAxes,'Pressure for Benedict Web Rubin Equation','Pressure About Table','FontSize',13)
title(app.UIAxes,'Comparing Equations')
        end

        % Button pushed function: BenedictWebbRubinButton_2
        function BenedictWebbRubinButton_2Pushed(app, event)
            cla(app.UIAxes)

R = 0.2968;
a_VanDerWalls = 0.175;
b_VanDerWalls = 0.00138;
R_u=8.314;           %Beattie-Bridgeman gas constant
M=28.013; %The molar of Nytrogen
a_Beattie_Bridgeman=0.02617; %a value from table 3-4
b_Beattie_Bridgeman=-0.00691; %b value from table 3-4
c_Beattie_Bridgeman=4.20*10^4; %c value from table 3-4
B_0=0.05046; %B_0 value from table 3-4
A_0=136.2315; %A_0 value from table 3-4

A_benedict_web_rubin = 106.73                   % invented constant 
a_benedict_web_rubin = 2.54                           % invented constant
b_benedict_web_rubin = 0.002328                  % invented constant
B_benedict_web_rubin= 0.04074                % invented constant
c_benedict_web_rubin = 7.379*10^4                 % invented constant
C_benedict_web_rubin = 8.164*10^5            % invented constant
alfa_benedict_web_rubin = 1.272*10^-4            % invented constant
gama_benedict_web_rubin = 0.0053                  % invented constant





%-----------------------Properties-------------------------
%Temperature (K)
A (:,:,1) = [63.1 80 105;65 85 110;70 90 115;75 95 120;77.3 100 125];
%Pressure About Table (kPa)
A (:,:,2) = [12.5 137 1084.6;17.4 229.1 1467.6;38.6 360.8 1939.3;76.1 541.1 2513;101.3 779.2 3208];
%Specific Volumes During Vapor
A (:,:,3) = [1.48189 0.16375 0.02218;1.09347 0.10148 0.01595;0.52632 0.06611 0.01144;0.28174 0.04476 0.00799;0.21639 0.03120 0.00490];
%Second Coefficient For Virial Equation Of State
A (:,:,4) = [-0.013851 -0.0087193 -0.0052135;-0.013069 -0.0077707 -0.0047714;-0.011285 -0.0069753 -0.0043811;-0.009868 -0.0062992 -0.0040341;-0.0092963 -0.0057181 -0.0037237];
%Third Coefficient For Virial Equation Of State
A (:,:,5) = [-0.000068509 -0.0000079963 0.000035529;-0.000055212 -0.0000029714 0.0000038703;-0.000030605 0.00000005557 0.0000040052;-0.000016389 0.00000187250 0.0000040261;-0.000011879 0.0000029446 0.0000039771];
%Forth Coefficient For Virial Equation Of State
A (:,:,6) = [0.000003799 0.00000026334 0.000000015385;0.000002719 0.00000013729 0.0000000094137;0.0000011631 0.000000075278 0.0000000057506;0.00000053551 0.000000043049 0.0000000034419;0.00000037989 0.000000025442 0.0000000019565];
Properties = reshape(A,[15,6]);
%------------------------While Loop------------------------
i = 1;
while i<=15
%------------Taking Properties From 3D Matrix--------------

T = Properties(i,1,1);                    %K
RealPressure = Properties(i,2,1);         %kPa
Specific_Volume = Properties(i,3,1);      %m^3/kg

%-------------------Benedict Webb Rubin--------------------
        
P_Benedict_Web_Rubin= ((R_u*T)/(M*Specific_Volume)) + (B_benedict_web_rubin*R_u*T - A_benedict_web_rubin - C_benedict_web_rubin/T^2)*(1/(M*Specific_Volume)^2) + ((b_benedict_web_rubin*R_u*T - a_benedict_web_rubin)/(M*Specific_Volume)^3) + ((a_benedict_web_rubin*alfa_benedict_web_rubin)/(M*Specific_Volume)^6) + (c_benedict_web_rubin/((M*Specific_Volume)^3*T^2))*(1+(gama_benedict_web_rubin/(M*Specific_Volume)^2))*10^(-gama_benedict_web_rubin/(M*Specific_Volume)^2);

%------To exit from while loop, we need to increase i------
i=i+1;
%-----------------Adding Equations to Arrays---------------
x_P_Benedict_Web_Rubin(i-1)=[P_Benedict_Web_Rubin]
%------Adding the Temperature and Pressure to 2D Array-----
t(i-1)=[T];
z(i-1)=[RealPressure];
v(i-1)=[Specific_Volume];
end
%-------------------Deviation Calculating------------------
j = 1;
while j<=15
    
    DeviationOfBenedictWebRubin=(x_P_Benedict_Web_Rubin(j)-Properties(j,2,1))/Properties(j,2,1)*100;
    j = j+1;
    DeviationArrayBWR(j-1)=[DeviationOfBenedictWebRubin];
end
            %---------------Plotting Deviation-P Graph------------------
yline(app.UIAxes,0,'LineWidth',2,'Color','g')
hold(app.UIAxes,"on")
plot(app.UIAxes,z,DeviationArrayBWR,'LineWidth',2,'Color','c')
legend(app.UIAxes,'Deviation Of Benedict Web Rubin Equation','FontSize',13)
title(app.UIAxes,'Deviation')
xlabel(app.UIAxes,'Pressure')
ylabel(app.UIAxes,'Deviation As Percentage')
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.AutoResizeChildren = 'off';
            app.UIFigure.Position = [100 100 1147 723];
            app.UIFigure.Name = 'MATLAB App';
            app.UIFigure.SizeChangedFcn = createCallbackFcn(app, @updateAppLayout, true);

            % Create GridLayout
            app.GridLayout = uigridlayout(app.UIFigure);
            app.GridLayout.ColumnWidth = {294, '1x', 294};
            app.GridLayout.RowHeight = {'1x'};
            app.GridLayout.ColumnSpacing = 0;
            app.GridLayout.RowSpacing = 0;
            app.GridLayout.Padding = [0 0 0 0];
            app.GridLayout.Scrollable = 'on';

            % Create LeftPanel
            app.LeftPanel = uipanel(app.GridLayout);
            app.LeftPanel.Layout.Row = 1;
            app.LeftPanel.Layout.Column = 1;

            % Create BeattieBridgemanButton
            app.BeattieBridgemanButton = uibutton(app.LeftPanel, 'push');
            app.BeattieBridgemanButton.ButtonPushedFcn = createCallbackFcn(app, @BeattieBridgemanButtonPushed, true);
            app.BeattieBridgemanButton.IconAlignment = 'center';
            app.BeattieBridgemanButton.Position = [77 421 140 22];
            app.BeattieBridgemanButton.Text = 'Beattie Bridgeman';

            % Create VanDerWallsButton
            app.VanDerWallsButton = uibutton(app.LeftPanel, 'push');
            app.VanDerWallsButton.ButtonPushedFcn = createCallbackFcn(app, @VanDerWallsButtonPushed, true);
            app.VanDerWallsButton.IconAlignment = 'center';
            app.VanDerWallsButton.Position = [77 489 140 22];
            app.VanDerWallsButton.Text = 'Van Der Walls';

            % Create IdealEquationOfStateButton
            app.IdealEquationOfStateButton = uibutton(app.LeftPanel, 'push');
            app.IdealEquationOfStateButton.ButtonPushedFcn = createCallbackFcn(app, @IdealEquationOfStateButtonPushed, true);
            app.IdealEquationOfStateButton.IconAlignment = 'center';
            app.IdealEquationOfStateButton.Position = [77 561 140 22];
            app.IdealEquationOfStateButton.Text = 'Ideal Equation Of State';

            % Create VirialEquationOfStateButton
            app.VirialEquationOfStateButton = uibutton(app.LeftPanel, 'push');
            app.VirialEquationOfStateButton.ButtonPushedFcn = createCallbackFcn(app, @VirialEquationOfStateButtonPushed, true);
            app.VirialEquationOfStateButton.IconAlignment = 'center';
            app.VirialEquationOfStateButton.Position = [77 281 140 22];
            app.VirialEquationOfStateButton.Text = 'Virial Equation Of State';

            % Create ComparingEquationsLabel
            app.ComparingEquationsLabel = uilabel(app.LeftPanel);
            app.ComparingEquationsLabel.HorizontalAlignment = 'center';
            app.ComparingEquationsLabel.Position = [77 620 140 22];
            app.ComparingEquationsLabel.Text = 'Comparing Equations';

            % Create BenedictWebbRubinButton
            app.BenedictWebbRubinButton = uibutton(app.LeftPanel, 'push');
            app.BenedictWebbRubinButton.ButtonPushedFcn = createCallbackFcn(app, @BenedictWebbRubinButtonPushed, true);
            app.BenedictWebbRubinButton.Position = [77 350 140 22];
            app.BenedictWebbRubinButton.Text = 'Benedict Webb Rubin';

            % Create ComparingPressuresButton
            app.ComparingPressuresButton = uibutton(app.LeftPanel, 'push');
            app.ComparingPressuresButton.ButtonPushedFcn = createCallbackFcn(app, @ComparingPressuresButtonPushed, true);
            app.ComparingPressuresButton.IconAlignment = 'center';
            app.ComparingPressuresButton.Position = [77 217 140 22];
            app.ComparingPressuresButton.Text = 'Comparing Pressures';

            % Create CenterPanel
            app.CenterPanel = uipanel(app.GridLayout);
            app.CenterPanel.Layout.Row = 1;
            app.CenterPanel.Layout.Column = 2;

            % Create UIAxes
            app.UIAxes = uiaxes(app.CenterPanel);
            title(app.UIAxes, 'Title')
            xlabel(app.UIAxes, 'X')
            ylabel(app.UIAxes, 'Y')
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.Position = [0 350 558 363];

            % Create RightPanel
            app.RightPanel = uipanel(app.GridLayout);
            app.RightPanel.Layout.Row = 1;
            app.RightPanel.Layout.Column = 3;

            % Create DeviationsofEquationsLabel
            app.DeviationsofEquationsLabel = uilabel(app.RightPanel);
            app.DeviationsofEquationsLabel.HorizontalAlignment = 'center';
            app.DeviationsofEquationsLabel.Position = [77 620 140 22];
            app.DeviationsofEquationsLabel.Text = 'Deviations of Equations';

            % Create IdealEquationOfStateButton_2
            app.IdealEquationOfStateButton_2 = uibutton(app.RightPanel, 'push');
            app.IdealEquationOfStateButton_2.ButtonPushedFcn = createCallbackFcn(app, @IdealEquationOfStateButton_2Pushed, true);
            app.IdealEquationOfStateButton_2.IconAlignment = 'center';
            app.IdealEquationOfStateButton_2.Position = [77 561 140 22];
            app.IdealEquationOfStateButton_2.Text = 'Ideal Equation Of State';

            % Create VanDerWallsButton_2
            app.VanDerWallsButton_2 = uibutton(app.RightPanel, 'push');
            app.VanDerWallsButton_2.ButtonPushedFcn = createCallbackFcn(app, @VanDerWallsButton_2Pushed, true);
            app.VanDerWallsButton_2.IconAlignment = 'center';
            app.VanDerWallsButton_2.Position = [77 489 140 22];
            app.VanDerWallsButton_2.Text = 'Van Der Walls';

            % Create BeattieBridgemanButton_2
            app.BeattieBridgemanButton_2 = uibutton(app.RightPanel, 'push');
            app.BeattieBridgemanButton_2.ButtonPushedFcn = createCallbackFcn(app, @BeattieBridgemanButton_2Pushed, true);
            app.BeattieBridgemanButton_2.IconAlignment = 'center';
            app.BeattieBridgemanButton_2.Position = [77 421 140 22];
            app.BeattieBridgemanButton_2.Text = 'Beattie Bridgeman';

            % Create BenedictWebbRubinButton_2
            app.BenedictWebbRubinButton_2 = uibutton(app.RightPanel, 'push');
            app.BenedictWebbRubinButton_2.ButtonPushedFcn = createCallbackFcn(app, @BenedictWebbRubinButton_2Pushed, true);
            app.BenedictWebbRubinButton_2.Position = [77 350 140 22];
            app.BenedictWebbRubinButton_2.Text = 'Benedict Webb Rubin';

            % Create VirialEquationOfStateButton_2
            app.VirialEquationOfStateButton_2 = uibutton(app.RightPanel, 'push');
            app.VirialEquationOfStateButton_2.ButtonPushedFcn = createCallbackFcn(app, @VirialEquationOfStateButton_2Pushed, true);
            app.VirialEquationOfStateButton_2.IconAlignment = 'center';
            app.VirialEquationOfStateButton_2.Position = [77 281 140 22];
            app.VirialEquationOfStateButton_2.Text = 'Virial Equation Of State';

            % Create DeviationsButton
            app.DeviationsButton = uibutton(app.RightPanel, 'push');
            app.DeviationsButton.ButtonPushedFcn = createCallbackFcn(app, @DeviationsButtonPushed, true);
            app.DeviationsButton.IconAlignment = 'center';
            app.DeviationsButton.Position = [77 217 140 22];
            app.DeviationsButton.Text = 'Deviations';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = Comparing_Equations_Of_States

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end