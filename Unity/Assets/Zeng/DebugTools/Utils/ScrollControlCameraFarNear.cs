using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Zeng.DebugTools
{
    public class ScrollControlCameraFarNear : MonoBehaviour
    {
        public float scrollSpeed = 1.0f; // 滚动速度
        public float cameraMinNear = -1; // 摄像机最近距离
        public float camerMaxFar = -50; // 摄像机最远距离
        
        public Transform cameraTransform; // 摄像机的 Transform
        
        void Start()
        {
            // 获取摄像机的 Transform
            if (Camera.main != null)
            {
                cameraTransform = Camera.main.transform;
            }

        }

        void Update()
        {
            if (Camera.main == null)
            {
                return;
            }
            // 获取鼠标滚轮的输入
            float scrollWheel = Input.GetAxis("Mouse ScrollWheel");
            float z = cameraTransform.localPosition.z;
            z =z + scrollWheel * scrollSpeed * Mathf.Abs(z) * 0.1f ;
            z = Mathf.Clamp(z, camerMaxFar, cameraMinNear);

            // 修改 GameObject 的 Z 轴位置
            cameraTransform.localPosition = Vector3.forward * z;
        }
    }
}
