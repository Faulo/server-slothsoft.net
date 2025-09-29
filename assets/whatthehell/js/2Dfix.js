Handle.prototype.init=function(x,y,owner){Handle.superclass.init.call(this,owner.svgNode);this.point=new Point2D(x,y);this.owner=owner;this.constrain=Handle.NO_CONSTRAINTS;}

RelativeLineto.prototype.toString=function(){var cmd="", points=new Array();var command="";var lastPoint;var point;if(this.previous)lastPoint=this.previous.getLastPoint();else lastPoint=new Point(0,0);point=this.handles[0].point.subtract(lastPoint);if(this.previous.constructor!=this.constuctor)if(this.previous.constructor!=RelativeMoveto)cmd=this.command;return cmd+point.toString();};

Path.prototype.translate=function(delta){
	var i, j;
	for (i = 0; i < this.segments.length; i++) {
		for (j = 0; j < this.segments[i].handles.length; j++) {
			this.segments[i].handles[j].translate(delta);
		}
	}
	this.refresh();
};

Path.prototype.intersectShape=function(shape){
	var result=new Intersection("No Intersection");
	//alert(this.segments.length);
	for(var i=0;i<this.segments.length;i++){
		//alert(this.segments[i].constructor);
		var inter=Intersection.intersectShapes(this.segments[i],shape);
		result.appendPoints(inter.points);
	}
	if(result.points.length>0)
		result.status="Intersection";
	return result;
};

Path.prototype.getIntersectionParams=function(){return new IntersectionParams("Path",[]);};

Intersection.intersectLineRectangle=function(a1,a2,r1,r2){
	//alert(a1+"\n"+a2+"\n"+r1+"\n"+r2+"\n");
	var min=r1.min(r2);
	var max=r1.max(r2);
	var topRight=new Point2D(max.x,min.y);
	var bottomLeft=new Point2D(min.x,max.y);
	var inter1=Intersection.intersectLineLine(min,topRight,a1,a2);
	var inter2=Intersection.intersectLineLine(topRight,max,a1,a2);
	var inter3=Intersection.intersectLineLine(max,bottomLeft,a1,a2);
	var inter4=Intersection.intersectLineLine(bottomLeft,min,a1,a2);
	var result=new Intersection("No Intersection");
	result.appendPoints(inter1.points);
	result.appendPoints(inter2.points);
	result.appendPoints(inter3.points);
	result.appendPoints(inter4.points);
	if(result.points.length>0)
		result.status="Intersection";
	return result;
};
Intersection.intersectBezier3Line=function(p1,p2,p3,p4,a1,a2){
	var a,b,c,d,roots;
	var c3,c2,c1,c0;
	var cl;
	var n;
	var min=a1.min(a2);
	var max=a1.max(a2);
	var result=new Intersection("No Intersection");
	a=p1.multiply(-1);
	b=p2.multiply(3);
	c=p3.multiply(-3);
	d=a.add(b.add(c.add(p4)));
	c3=new Vector2D(d.x,d.y);
	a=p1.multiply(3);
	b=p2.multiply(-6);
	c=p3.multiply(3);
	d=a.add(b.add(c));
	c2=new Vector2D(d.x,d.y);
	a=p1.multiply(-3);
	b=p2.multiply(3);
	c=a.add(b);
	c1=new Vector2D(c.x,c.y);
	c0=new Vector2D(p1.x,p1.y);
	n=new Vector2D(a1.y-a2.y,a2.x-a1.x);
	cl=a1.x*a2.y-a2.x*a1.y;
	roots=new Polynomial(n.dot(c3),n.dot(c2),n.dot(c1),n.dot(c0)+cl).getRoots();
	for(var i=0;
	i<roots.length;
	i++){var t=roots[i];
	if(0<=t&&t<=1){var p5=p1.lerp(p2,t);
	var p6=p2.lerp(p3,t);
	var p7=p3.lerp(p4,t);
	var p8=p5.lerp(p6,t);
	var p9=p6.lerp(p7,t);
	var p10=p8.lerp(p9,t);
	if(a1.x==a2.x){if(min.y<=p10.y&&p10.y<=max.y){result.status="Intersection";
	result.appendPoint(p10);
	}}else if(a1.y==a2.y){if(min.x<=p10.x&&p10.x<=max.x){result.status="Intersection";
	result.appendPoint(p10);
	}}else if(p10.gte(min)&&p10.lte(max)){result.status="Intersection";
	result.appendPoint(p10);
	}}}return result;
};





Rectangle.prototype.__init=function(svgNode){
	if(svgNode.localName=="rect"){
		Rectangle.superclass.init.call(this,svgNode);
		var x=Intersection.getX(svgNode);
		var y=Intersection.getY(svgNode);
		var width=Intersection.getWidth(svgNode);
		var height=Intersection.getWidth(svgNode);
		this.p1=new Handle(x,y,this);
		this.p2=new Handle(x+width,y+height,this);
	}else{
		throw new Error("Rectangle.init: Invalid SVG Node: "+svgNode.localName);
	}
};

Rectangle.prototype.translate=function(delta){
	this.p1.translate(delta);
	this.p2.translate(delta);
	this.refresh();
};
Polynomial.prototype.getRootsInInterval=function(min,max){var roots=new Array();
	var root;
	if(this.getDegree()==1){root=this.bisection(min,max);
	if(root!=null)roots.push(root);
	}else{var deriv=this.getDerivative();
	var droots=deriv.getRootsInInterval(min,max);
	if(droots.length>0){root=this.bisection(min,droots[0]);
	if(root!=null)roots.push(root);
	for(var i=0;
	i<=droots.length-2;
	i++){root=this.bisection(droots[i],droots[i+1]);
	if(root!=null)roots.push(root);
	}root=this.bisection(droots[droots.length-1],max);
	if(root!=null)roots.push(root);
	}else{root=this.bisection(min,max);
	if(root!=null)roots.push(root);
	}}return roots;
};
Polynomial.prototype.getCubicRoots=function(){var results=new Array();
	if(this.getDegree()==3){var c3=this.coefs[3];
	var c2=this.coefs[2]/c3;
	var c1=this.coefs[1]/c3;
	var c0=this.coefs[0]/c3;
	var a=(3*c1-c2*c2)/3;
	var b=(2*c2*c2*c2-9*c1*c2+27*c0)/27;
	var offset=c2/3;
	var discrim=b*b/4 + a*a*a/27;
	var halfB=b/2;
	if(Math.abs(discrim)<=Polynomial.TOLERANCE)discrim=0;
	if(discrim>0){var e=Math.sqrt(discrim);
	var tmp;
	var root;
	tmp=-halfB+e;
	if(tmp>=0)root=Math.pow(tmp,1/3);
	else root=-Math.pow(-tmp,1/3);
	tmp=-halfB-e;
	if(tmp>=0)root+=Math.pow(tmp,1/3);
	else root-=Math.pow(-tmp,1/3);
	results.push(root-offset);
	}else if(discrim<0){var distance=Math.sqrt(-a/3);
	var angle=Math.atan2(Math.sqrt(-discrim),-halfB)/3;
	var cos=Math.cos(angle);
	var sin=Math.sin(angle);
	var sqrt3=Math.sqrt(3);
	results.push(2*distance*cos-offset);
	results.push(-distance*(cos+sqrt3*sin)-offset);
	results.push(-distance*(cos-sqrt3*sin)-offset);
	}else{var tmp;
	if(halfB>=0)tmp=-Math.pow(halfB,1/3);
	else tmp=Math.pow(-halfB,1/3);
	results.push(2*tmp-offset);
	results.push(-tmp-offset);
	}}return results;
};


