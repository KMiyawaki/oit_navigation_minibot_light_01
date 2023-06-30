#!/usr/bin/env python
# -*- coding: utf-8 -*-

import copy
import rospy
import cv2
from vision_msgs.msg import Detection2DArray
from opencv_apps.msg import Rect, RectArray
from sensor_msgs.msg import Image
from threading import Lock
from cv_bridge import CvBridge


class CountTarget(object):
    def __init__(self):
        self.class_labels = []
        topic_detections = rospy.get_param(
            '~topic_detections', '/detectnet/detections')
        self.target = rospy.get_param('~target', 'person')
        topic_detected_targets = rospy.get_param(
            '~topic_detected_targets', '~detected_targets')
        topic_image_in = rospy.get_param(
            '~topic_image_in', '/video_source/raw')
        topic_image_out = rospy.get_param('~topic_image_out', '~image_out')
        label_file = rospy.get_param(
            '~label_file', '/home/jetson/jetson-inference/data/networks/SSD-Mobilenet-v2/ssd_coco_labels.txt')
        rospy.Subscriber(topic_detections, Detection2DArray, self.cb_detection)
        rospy.Subscriber(topic_image_in, Image, self.cb_image)
        self.detected_targets_pub = rospy.Publisher(
            topic_detected_targets, RectArray, queue_size=1)
        self.image_pub = rospy.Publisher(topic_image_out, Image, queue_size=1)
        self.load_class_labels(label_file)
        self.target_id = self.class_labels.index(self.target)
        self.bbox_lock = Lock()
        self.bboxes = []
        self.bridge = CvBridge()
        rospy.loginfo('Start detection. target=%s, target_id=%d',
                      self.target, self.target_id)

    def cb_image(self, data):
        bboxes = []
        rects = RectArray()
        self.bbox_lock.acquire()
        bboxes = copy.deepcopy(self.bboxes)
        self.bbox_lock.release()
        cv_array = self.bridge.imgmsg_to_cv2(data, "bgr8")
        for b in bboxes:
            r = Rect()
            r.x = b.center.x - b.size_x / 2
            r.y = b.center.y - b.size_y / 2
            r.width = b.size_x
            r.height = b.size_y
            pt1 = (int(r.x), int(r.y))
            pt2 = (int(r.x + r.width), int(r.y + r.height))
            cv2.rectangle(cv_array, pt1, pt2, color=(0, 255, 0),
                          thickness=3, lineType=cv2.LINE_4, shift=0)
            rects.rects.append(r)
        msg = self.bridge.cv2_to_imgmsg(cv_array, "bgr8")
        self.image_pub.publish(msg)
        if rects.rects:
            self.detected_targets_pub.publish(rects)

    def cb_detection(self, data):
        bboxes = []
        for d in data.detections:
            for r in d.results:
                if r.id == self.target_id:
                    bboxes.append(d.bbox)
                    break
        self.bbox_lock.acquire()
        self.bboxes = copy.deepcopy(bboxes)
        self.bbox_lock.release()

    def load_class_labels(self, file_name):
        f = open(file_name)
        for l in f:
            self.class_labels.append(l.strip())
        f.close()
        # rospy.loginfo("Classes" + str(class_labels))


def main():
    rospy.init_node('count_target')
    _ = CountTarget()
    rospy.spin()


if __name__ == '__main__':
    main()
