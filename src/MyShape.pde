class MyShape extends PShape{
  PVector pos = new PVector(0,0);
  float rot = 0;
  PVector scale = new PVector(0,0);
  
}

public MyShape mycircle(float r){
  MyShape s = new MyShape();
  s = createShape(ELLIPSE,0,0,r,r);
  return s;
}
