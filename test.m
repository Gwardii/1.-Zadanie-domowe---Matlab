[elements,connections]=read('test.xlsx');
elements(2).angle = pi/2;
elements(3).angle = asin(4/5);
q=[];
% for element = elements(2:end)
%     q(end+1:end+3) = [element.ACS_cm;element.angle];
% end
q=[0,0,pi,-1,0,atan(4/3),2,4,0];
q=q';
[FI,FI_q] = constraints(q,elements,connections);