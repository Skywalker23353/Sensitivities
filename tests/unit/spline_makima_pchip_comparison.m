%   Example: Compare SPLINE, PCHIP, and MAKIMA
      fs = 33
      x = [0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1];
      y = [0 0 0 0.5 0.4 1.2 1.2 0.1 0 0.3 0.6];
      xq = -0.01:0.05:1.05;
      yqs = spline(x,y,xq);
      yqp = pchip(x,y,xq);
      yqm = makima(x,y,xq);

      plot(x,y,'ko','LineWidth',2,'MarkerSize',10)
      hold on
      plot(xq,yqp,'LineWidth',4)
      plot(xq,yqs,xq,yqm,'LineWidth',2)
      
      legend('(x,y) data','pchip','spline','makima')
      set(findall(gca,'-property','FontSize'),'FontSize',fs);
set(findall(gca,'-property','LineWidth'),'LineWidth',2);