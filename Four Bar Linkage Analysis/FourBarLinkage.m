clc
clear
close all 

[x_p, y_p, x_B, y_B, w3, w4, AngularAcc3, AngularAcc4, thetaD, delta, phi, theta3, theta4, Time, D] = fourbarlink(0.4,0.2,0.4,0.4,0.3,pi/6,0,600,0);
figure
PartB = fourbarlink(0.4,0.35,0.4,0.5,0.3,pi/6,0,600,0);

function [x_p, y_p, x_B, y_B, w3, w4, AngularAcc3, AngularAcc4, thetaD, delta, phi, theta3, theta4, Time, D] = fourbarlink(FixedLink, CrankLink, CouplerLink, OutputLink, CouplerExtension, CouplerExtensionAngle, theta1, AngularVelocity2, AngularAcc2)

    theta1 = deg2rad(theta1);
    theta2 = deg2rad(0:1:360);

    D = sqrt((FixedLink^2)+(CrankLink^2)-2*FixedLink*CrankLink*cos(theta2));
    Dx = FixedLink*cos(theta1)-CrankLink.*cos(theta2);
    Dy = FixedLink*sin(theta1)-CrankLink.*sin(theta2);
    thetaD = atan(Dy./Dx);

    delta = abs(acos(((OutputLink^2)+(D.^2)-(CouplerLink^2))./(2*OutputLink.*D)));
    phi = abs(acos(((CouplerLink^2)+(D.^2)-(OutputLink^2))./(2*CouplerLink.*D)));

    theta3 = phi+thetaD;
    theta4 = thetaD+(pi-delta);

    x_p = CrankLink*cos(theta2)+CouplerExtension*cos(theta3+CouplerExtensionAngle);
    y_p = CrankLink*sin(theta2)+CouplerExtension*sin(theta3+CouplerExtensionAngle);

    x_B = FixedLink*cos(theta1) + OutputLink.*cos(180-theta4);
    y_B = FixedLink*sin(theta1) + OutputLink.*sin(180-theta4);

    w3 = (-AngularVelocity2*CrankLink.*sin(theta4-theta2))./(CouplerLink.*sin(theta4-theta3));
    w4 = (AngularVelocity2*CrankLink.*sin(theta3-theta2))./(OutputLink*sin(theta3-theta4));

    AngularAcc3 = (-CrankLink*AngularAcc2.*sin(theta4-theta2)+CrankLink*(AngularVelocity2^2).*cos(theta4-theta2)+CouplerLink*(w3.^2).*cos(theta4-theta3)-OutputLink*(w4.^2))./(CouplerLink.*sin(theta4-theta3));
    AngularAcc4 = (CrankLink*AngularAcc2.*sin(theta3-theta2)-CrankLink*(AngularVelocity2^2).*cos(theta3-theta2)+OutputLink.*(w4.^2).*cos(theta3-theta4)-CouplerLink.*(w3.^2))./(OutputLink.*sin(theta3-theta4));

    % Time
    AngularVelo = rad2deg(AngularVelocity2);
    FirstDegTime = 10^3/AngularVelo;
    LastDegTime = 360*FirstDegTime;

    subplot(2,2,1)
    h1 = animatedline;
    xlim([min(theta2),max(theta2)])
    ylim([min(theta3),max(theta3)])
    title("\theta_2 vs \theta_3")
    xlabel("\theta_2")
    ylabel("\theta_3")

    subplot(2,2,2)
    h2 = animatedline;
    xlim([min(theta2),max(theta2)])
    ylim([min(theta4),max(theta4)])
    title("\theta_2 vs \theta_4")
    xlabel("\theta_2")
    ylabel("\theta_4")

    subplot(2,2,3)
    h3 = animatedline;
    xlim([-0.5,0.7])
    ylim([-0.5,0.7])
    title("X and Y Position of Point P")
    xlabel("X")
    ylabel("Y")

    subplot(2,2,4)
    h4 = animatedline;
    xlim([-0.5,0.7])
    ylim([-0.5,0.7])
    title("X and Y Position of Point B")
    xlabel("X")
    ylabel("Y")

    for a = 1:361
        addpoints(h1,theta2(a),theta3(a))
        addpoints(h2,theta2(a),theta4(a))
        addpoints(h3,x_p(a),y_p(a))
        addpoints(h4,x_B(a),y_B(a))
        drawnow
    end

    figure
    subplot(2,2,1)
    h5 = animatedline; 
    xlim([0,LastDegTime])
    ylim([min(w3),max(w3)])
    title("\omega_3 vs Time")
    xlabel("Time")
    ylabel("\omega_3")

    subplot(2,2,2)
    h6 = animatedline;
    xlim([0,LastDegTime])
    ylim([min(w4),max(w4)])
    title("\omega_4 vs Time")
    xlabel("Time")
    ylabel("\omega_4")

    subplot(2,2,3)
    xlim([0,LastDegTime])
    ylim([min(AngularAcc3),max(AngularAcc3)])
    h7 = animatedline;
    title("\alpha_3 vs Time")
    xlabel("Time")
    ylabel("\alpha_3")

    subplot(2,2,4)
    h8 = animatedline;
    xlim([0,LastDegTime])
    ylim([min(AngularAcc4),max(AngularAcc4)])
    title("\alpha_4 vs Time")
    xlabel("Time")
    ylabel("\alpha_4")

    for b = 1:361
        Time(b) = b*FirstDegTime;
        addpoints(h5,Time(b),w3(b))
        addpoints(h6,Time(b),w4(b))
        addpoints(h7,Time(b),AngularAcc3(b))
        addpoints(h8,Time(b),AngularAcc4(b))
        drawnow
    end

end