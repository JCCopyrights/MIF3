
function Y=refine(X)
	for i=1:1:length(X)-1
		Y(:,2*i-1)=X(:,i);
		Y(:,2*i)=(X(:,i+1)+X(:,i))./2;
	end	
end