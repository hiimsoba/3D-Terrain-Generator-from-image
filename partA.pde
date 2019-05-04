import peasy.*;

// will create the heightmap from this
PImage mapImage;

float heightMap[][];

float spacing = 100.0; // Use this variable to set the spacing between heightmap elements
PeasyCam cam;
float startXY;

void setup() {
  //size(800, 480, P3D);  
  fullScreen(P3D);

  cam = new PeasyCam(this, 1000);
  cam.setMinimumDistance(50);
  cam.setMaximumDistance(5000);

  // load the image
  mapImage = loadImage("map3.jpg");

  // resize it so that it's not... huge
  mapImage.resize(floor(0.15 * mapImage.width), floor(0.15 * mapImage.height));

  // initialize
  heightMap = new float[mapImage.height][mapImage.width];
  // and add the values corresponding to the values of the pixels from the image
  for (int y = 0; y < heightMap.length; ++y) {
    for (int x = 0; x < heightMap[y].length; ++x) {
      // get the color of the pixel at x, y
      color pix = mapImage.get(x, y);
      // and get its brightness ( sum of the R, G, B divided by 3 )
      float bright = (float) (red(pix) + green(pix) + blue(pix)) / 3;
      // set the brightness to be the height of a spot at (x, y)
      // will be between 0 and 255
      heightMap[y][x] = bright;
    }
  }

  startXY = (heightMap.length * spacing) / 2;    // This is to recentre the heightmap
  // for smoother strips, looks better.
  smooth(102400);
}

void draw() {
  background(51);
  // rotate on the X so we get a better viewing angle
  rotateX(QUARTER_PI);
  translate(-startXY, -startXY, 0);
  // add lights to better distinguish the faces of the terrain
  lights();
  stroke(0);
  fill(255);
  // draw the terrain
  drawTerrain(heightMap);
}

void drawTerrain(float[][] heights) {
  // for each y ( row of the heightmap )
  for (int y = 0; y < heights.length - 1; ++y) {
    // we're gonna use beginShape() with the quad strip argument
    beginShape(QUAD_STRIP);
    // and then set the vertices for each row
    // so for each x ( column of heightmap )
    for (int x = 0; x < heights[y].length; ++x) {
      // set a vertex at x * spacing, y * spacing - startXY ( so we get a better viewing point )
      vertex(x * spacing, y * spacing, heights[y][x]);
      // and one at x * spacing and (y + 1) * spacing - startXY
      // since we take a vertex from the top and one from the bottom
      // and the height will be heightMap[y][x] and heightMap[y + 1][x]
      vertex(x * spacing, (y + 1) * spacing, heights[y + 1][x]);
    }
    endShape();
  }
}
