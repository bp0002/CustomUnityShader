# Custom Tail - Control By Quadratic Bezier curves

* Mesh Use 'Plane':
  * x 坐标范围 [ -5 ~ 5 ], Shader 中转换为 [ -1 ~ 1 ] 使用
  * y in [ 0 ~ 0 ]
  * z 坐标范围 [ -5 ~ 5 ], Shader 中转换为 [ -1 ~ 1 ] 使用
* 渲染:
  * 始终面向相机
    * 曲线切线向量 在 以相机方向为法向量的平面 的投影向量 与 相机方向的叉积向量，向叉积向量的正反两个方向挤出为面片
