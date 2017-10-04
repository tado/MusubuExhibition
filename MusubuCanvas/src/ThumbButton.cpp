#include "ThumbButton.h"
#include "ofApp.h"

ThumbButton::ThumbButton(int num, string imgname, ofVec2f position, int width, int height) {
	img.load(imgname);
	this->num = num;
	this->position = position;
	this->width = width;
	this->height = height;
	selected = false;
}

void ThumbButton::draw() {
	if (selected) {
		ofSetColor(255);
	}
	else {
		ofSetColor(127);
	}
	img.draw(position.x, position.y, width, height);
}

void ThumbButton::mouseMoved(int x, int y) {
	if (x > position.x
		&& x < position.x + width
		&& y > position.y
		&& y < position.y + height
		) {
		selected = true;
	}
	else {
		selected = false;
	}
}

void ThumbButton::mouseReleased(int x, int y, int button){
	ofApp *app = ((ofApp*)ofGetAppPtr());
	if (x > position.x
		&& x < position.x + width
		&& y > position.y
		&& y < position.y + height
		) {
		app->switchSketch(num);
	}
}