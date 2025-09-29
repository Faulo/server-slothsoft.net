Adventure.View.Map.Item = Trait.build({
	uses : [
	],
	construct : function(ownerMap, svgNode) {
		var i;
		this.ownerMap = ownerMap;
		this.node = svgNode;
		this.node.setAttribute("buffer-rendering", "static");
		this.node.item = this;
		this.moveTo(0, 0);
		this.nodeList = this.node.childNodes;
		this.shapeList = [];
		for (i = 0; i < this.nodeList.length; i++) {
			this.nodeList[i].item = this;
			this.shapeList[i] = this.getShape(this.nodeList[i]);
			this.nodeList[i].addEventListener(
				"click",
				function(eve) {
					if (this.item.followMouse) {
						this.item.events.letgo.call(this, eve);
					} else {
						this.item.events.follow.call(this, eve);
					}
				},
				false
			);
			/*
			this.nodeList[i].addEventListener(
				"dblclick",
				this.events.letgo,
				false
			);
			//*/
		}
		this.moveVector = [
			[
				new Vector2D(0, 0),
				new Vector2D(0, 0)
			],
			[
				new Vector2D(0, 0),
				new Vector2D(0, 0)
			]
		];
	},
	vars : {
		ownerMap		: undefined,
		node			: undefined,
		nodeList		: undefined,
		shapeList		: undefined,
		x				: 0,
		y				: 0,
		moving			: true,
		moveVector		: undefined,
		followMouse		: false,
		followMouseX	: 0,
		followMouseY	: 0,
		events			: {
			follow : function(eve) {
				this.item.followMouse = true;
				this.item.ownerMap.ownerView.mouseFollower = this.item;
				this.item.followMouseX = eve.pageX;
				this.item.followMouseY = eve.pageY;
				this.item.node.parentNode.appendChild(this.item.node);
			},
			letgo : function(eve) {
				this.item.followMouse = false;
				this.item.ownerMap.ownerView.mouseFollower = false;
				if (eve.which === 1) {
					this.item.drop();
				} else {
					this.item.fixate();
				}
			},
			update : function(eve) {
				this.item.moveBy(eve.pageX - this.item.followMouseX, eve.pageY - this.item.followMouseY);
				this.item.followMouseX = eve.pageX;
				this.item.followMouseY = eve.pageY;
			},
		}
	},
	methods : {
		getShape : function(ele) {
			switch (ele.localName) {
				case "circle":  return new Circle(ele);
				case "ellipse": return new Ellipse(ele);
				case "line":    return new Line(ele);
				case "path":    return new Path(ele);
				case "polygon": return new Polygon(ele);
				case "rect":    return new Rectangle(ele);
				default:
					// do nothing for now
			}
			return false;
		},
		collides : function(testItem) {
			var i, j, res;
			for (i = 0; i < this.shapeList.length; i++) {
				for (j = 0; j < testItem.shapeList.length; j++) {
					if (Intersection.intersectShapes(this.shapeList[i], testItem.shapeList[j]).points.length) {
						this.turn();
						while (this.move() && Intersection.intersectShapes(this.shapeList[i], testItem.shapeList[j]).points.length);
						return true;
					}
				}
			}
			return false;
		},
		turn : function(deg) {
			var v = this.moveVector[0][1];
			v.y *= -0.6;
			if (Math.abs(v.y) < 2) {
				v.x = 0;
				v.y = 0;
				this.moving = false;
			}
			//= new Vector2D(this.moveVector[0][1].x, - this.moveVector[0][1].y);
			//this.moveVector[0][1] = new Vector2D(0, 0);
		},
		fixate : function() {
			this.moving = false;
			this.moveVector[0][0] = new Vector2D(0, 0);
			this.moveVector[0][1] = new Vector2D(0, 0);
		},
		drop : function() {
			this.moving = true;
			this.moveVector[0][0] = new Vector2D(0, 0.5);
			this.moveVector[0][1] = new Vector2D(0, 0);
		},
		move : function() {
			if (this.followMouse) {
				this.moveVector[0][1].x = 0;
				this.moveVector[0][1].y = 0;
			} else if (this.moving) {
				var i, a, v;
				for (i = 0; i < this.moveVector.length; i++) {
					a = this.moveVector[i][0];
					v = this.moveVector[i][1];
					v.addEquals(a);
					this.moveBy(v.x, v.y);
				}
				return !!this.moveVector.length;
			}
			return false;
		},
		moveBy : function(x, y) {
			this.x += x;
			this.y += y;
			var i, point;
			point = new Point2D(x, y);
			for (i = 0; i < this.shapeList.length; i++) {
				this.shapeList[i].translate(point);
			}
			this.refresh();
		},
		moveTo : function(x, y) {
			this.x = x;
			this.y = y;
			this.refresh();
		},
		getPos : function() {
			return {
				x : this.x,
				y : this.y
			};
		},
		refresh : function() {
			//this.node.setAttribute("transform", "translate("+this.x+", "+this.y+")");
		},
	}
});