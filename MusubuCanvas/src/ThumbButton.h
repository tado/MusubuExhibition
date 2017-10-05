#pragma once
#include "ofMain.h"

class ThumbButton {
public:
	ThumbButton(int num, string imgname, string nameImgName, ofVec2f position, int width, int height);
	void draw();
	void mouseMoved(int x, int y);
	void mouseReleased(int x, int y, int button);

	int num;
	ofImage img;
	ofImage nameImg;
	ofVec2f position;
	int width;
	int height;
	bool selected;
	bool running;
};

