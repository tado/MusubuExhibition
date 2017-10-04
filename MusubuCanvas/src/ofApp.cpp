#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){
	sender.setup("127.0.0.1", 12000);
	ofSetFrameRate(60);
	ofBackground(0);
	current = -1;
	total = 10;

	title.loadImage("title.png");
	for (int i = 0; i < 11; i++){
		string filename = to_string(i) + ".jpg";
		cout << filename << endl;
		thumb[i].load(filename);
	}

	//ofToggleFullscreen();
}

//--------------------------------------------------------------
void ofApp::update(){

}

//--------------------------------------------------------------
void ofApp::draw(){
	title.draw(80, 160);

	int col = 4;
	int row = 3;
	int imageWidth = ofGetWidth() / col;
	int imageHeight = ofGetHeight() / 1.5 / row;

	for (int j = 0; j < row; j++) {
		for (int i = 0; i < col; i++) {
			if (j * col + i < 11) {
				int x = i * imageWidth;
				int y = ofGetHeight() / 3 + j * imageHeight;
				thumb[j * col + i].draw(x, y, imageWidth, imageHeight);
			}
		}
	}
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

}

//--------------------------------------------------------------
void ofApp::mouseDragged(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mousePressed(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mouseReleased(int x, int y, int button){

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
