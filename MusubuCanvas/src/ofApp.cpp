#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){
	sender.setup("127.0.0.1", 12000);
	ofSetFrameRate(60);
	ofBackground(0);
	current = -1;
	total = 10;

	title.loadImage("title.png");

	int col = 4;
	int row = 3;
	int imageWidth = ofGetWidth() / col;
	int imageHeight = ofGetHeight() / 1.5 / row;

	for (int j = 0; j < row; j++) {
		for (int i = 0; i < col; i++) {
			if (j * col + i < 11) {
				string filename = to_string(j * col + i) + ".jpg";
				string nameImgName = "name"+ to_string(j * col + i) + ".png";
				int x = i * imageWidth;
				int y = ofGetHeight() / 3 + j * imageHeight;
				ofVec2f pos;
				pos.set(x, y);
				ThumbButton *t = new ThumbButton(j*col+i, filename, nameImgName, pos, imageWidth, imageHeight);
				thumb.push_back(t);
			}
		}
	}

	//ofToggleFullscreen();
}

//--------------------------------------------------------------
void ofApp::update(){

}

//--------------------------------------------------------------
void ofApp::draw(){
	ofSetColor(255);
	title.draw(80, 160);

	for (int i = 0; i < thumb.size(); i++) {
		thumb[i]->draw();
	}
}

void ofApp::switchSketch(int n) {
	for (int i = 0; i < thumb.size(); i++) {
		thumb[i]->running = false;
	}
	ofxOscMessage m;
	m.setAddress("/switch");
	m.addIntArg(n);
	sender.sendMessage(m, false);
	cout << "send osc : current = " << n << endl;
}

//--------------------------------------------------------------
void ofApp::keyPressed(int key){
	if (key == ' ') {
		ofxOscMessage m;
		current = (current++) % total;
		m.setAddress("/switch");
		m.addIntArg(current);
		sender.sendMessage(m, false);
		cout << "send osc : current = " << current << endl;
	}
}

//--------------------------------------------------------------
void ofApp::keyReleased(int key){

}

//--------------------------------------------------------------
void ofApp::mouseMoved(int x, int y ){
	for (int i = 0; i < thumb.size(); i++) {
		thumb[i]->mouseMoved(x, y);
	}
}

//--------------------------------------------------------------
void ofApp::mouseDragged(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mousePressed(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mouseReleased(int x, int y, int button){
	for (int i = 0; i < thumb.size(); i++) {
		thumb[i]->mouseReleased(x, y, button);
	}
}

//--------------------------------------------------------------
void ofApp::mouseEntered(int x, int y){

}

//--------------------------------------------------------------
void ofApp::mouseExited(int x, int y){

}

//--------------------------------------------------------------
void ofApp::windowResized(int w, int h){

}

//--------------------------------------------------------------
void ofApp::gotMessage(ofMessage msg){

}

//--------------------------------------------------------------
void ofApp::dragEvent(ofDragInfo dragInfo){ 

}
