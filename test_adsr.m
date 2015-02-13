t=linspace(0,1,1000);

adsr1 = getADSR(100,400,400,100,0,1,0.8,0);
adsr2 = getADSR(100,400,400,100,0,1,0.5,0);

figure;
plot(t,adsr1);
xlabel('Beat');
ylabel('Power');
grid on;
set(gca,'YTick',0:0.2:1);
set(gca,'XTick',0:0.5:1);

figure;
plot(t,adsr2);
xlabel('Beat');
ylabel('Power');
grid on;
set(gca,'YTick',0:0.25:1);
set(gca,'XTick',0:0.5:1);
