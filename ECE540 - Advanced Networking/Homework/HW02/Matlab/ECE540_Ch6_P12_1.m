figure(1); clf
p=0:0.001:1;
N1=10;N2=30;N3=50;
eff1=N1.*p.*(1-p).^(N1-1);
eff2=N2.*p.*(1-p).^(N2-1);
eff3=N3.*p.*(1-p).^(N3-1);
hold
plot(p,eff1,'g','LineWidth',3)
plot(p,eff2,'r','LineWidth',3)
plot(p,eff3,'y','LineWidth',3)
xlabel('Probability')
ylabel('Efficiency')
title('Slotted ALOHA')
legend('N = 10','N = 30','N = 50')