#!/usr/bin/env python
# -*- coding: utf-8 -*-

import copy
import rospy
import cv2
from vision_msgs.msg import Detection2DArray
from std_msgs.msg import Int32
from sensor_msgs.msg import Image
from threading import Lock
from cv_bridge import CvBridge


class CountTarget(object):
    def __init__(self):
        self.class_labels = []
        topic_detections = rospy.get_param(
            '~topic_detections', '/detectnet/detections')
        self.target = rospy.get_param('~target', 'person')
        topic_count = rospy.get_param('~topic_count', '~count')
        topic_image_in = rospy.get_param(
            '~topic_image_in', '/video_source/raw')
        topic_image_out = rospy.get_param('~topic_image_out', '~image_out')
        label_file = rospy.get_param(
            '~label_file', '/home/jetson/jetson-inference/data/networks/SSD-Mobilenet-v2/ssd_coco_labels.txt')
        rospy.Subscriber(topic_detections, Detection2DArray, self.cb_detection)
        rospy.Subscriber(topic_image_in, Image, self.cb_image)
        self.count_pub = rospy.Publisher(topic_count, Int32, queue_size=1)
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
        self.bbox_lock.acquire()
        bboxes = copy.deepcopy(self.bboxes)
        self.bbox_lock.release()
        cv_array = self.bridge.imgmsg_to_cv2(data, "bgr8")
        for b in bboxes:
            w = b.size_x / 2
            h = b.size_y / 2
            pt1 = (int(b.center.x - w), int(b.center.y - h))
            pt2 = (int(b.center.x + w), int(b.center.y + h))
            cv2.rectangle(cv_array, pt1, pt2, color=(0, 255, 0),
                          thickness=3, lineType=cv2.LINE_4, shift=0)
        msg = self.bridge.cv2_to_imgmsg(cv_array, "bgr8")
        self.image_pub.publish(msg)

    def cb_detection(self, data):
        bboxes = []
        for d in data.detections:
            for r in d.results:
                if r.id == self.target_id:
                    bboxes.append(d.bbox)
                    break
        count = len(bboxes)
        if count > 0:
            rospy.loginfo('%s:count %d', self.target, count)
            self.count_pub.publish(count)
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
