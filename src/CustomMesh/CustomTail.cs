using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using UnityEngine;

namespace Assets.CustomMesh
{
    [RequireComponent(typeof(MeshFilter), typeof(MeshRenderer))]
    public class CustomTail : MonoBehaviour
    {
        public int xSize, ySize;
        public Vector3 gridStart = new Vector3(0, 0, 0);
        public Vector3 gridEnd = new Vector3(1, 0, 1);

        private Vector3[] vertices;

        private Mesh mesh;

        private void Awake()
        {
            // 
            //StartCoroutine(Generate());

            Generate();
        }

        //private IEnumerator Generate()
        //{
        //    WaitForSeconds wait = new WaitForSeconds(0.5f);

        //    GetComponent<MeshFilter>().mesh = mesh = new Mesh();
        //    mesh.name = "Custom Grid";

        //    vertices = new Vector3[(xSize + 1) * (ySize + 1)];

        //    for (int i = 0, y = 0; y <= ySize; y++)
        //    {
        //        for (int x = 0; x <= xSize; x++, i++)
        //        {
        //            vertices[i] = new Vector3(x, y);
        //        }
        //    }

        //    mesh.vertices = vertices;

        //    int[] triangles = new int[xSize * ySize * 6];
        //    // y: 0 ~ y-1
        //    for (int ti = 0, vi = 0, y = 0; y < ySize; y++, vi++)
        //    {
        //        // x: 0 ~ x-1
        //        for (int x = 0; x < xSize; x++, ti += 6, vi++)
        //        {
        //            int start = vi + 0;
        //            triangles[ti + 0] = start;
        //            triangles[ti + 3] = triangles[ti + 2] = start + 1;
        //            triangles[ti + 4] = triangles[ti + 1] = xSize + start + 1;
        //            triangles[ti + 5] = xSize + start + 2;

        //            mesh.triangles = triangles;
        //            yield return wait;
        //        }
        //    }
        //}

        private void Generate()
        {
            //WaitForSeconds wait = new WaitForSeconds(0.5f);
            Vector3 extendX = gridEnd - gridStart;

            GetComponent<MeshFilter>().mesh = mesh = new Mesh();
            mesh.name = "Custom Grid";

            vertices = new Vector3[(xSize + 1) * (ySize + 1)];
            for (int i = 0, y = 0; y <= ySize; y++)
            {
                for (int x = 0; x <= xSize; x++, i++)
                {
                    var temp = new Vector3((float)x / xSize, (float)0, (float)y / ySize);
                    temp.x *= extendX.x;
                    temp.y *= extendX.y;
                    temp.z *= extendX.z;
                    vertices[i] = gridStart + temp;
                    Debug.Log(vertices[i]);
                }
            }
            mesh.vertices = vertices;

            Vector2[] uv = new Vector2[(xSize + 1) * (ySize + 1)];
            for (int i = 0, y = 0; y <= ySize; y++)
            {
                for (int x = 0; x <= xSize; x++, i++)
                {
                    uv[i] = new Vector2((float)x / xSize, (float)y / ySize);
                }
            }
            mesh.uv = uv;

            Vector4[] tangents = new Vector4[(xSize + 1) * (ySize + 1)];
            Vector4 tempTangent = new Vector4(1f, 0f, 0f, -1f);
            for (int i = 0, y = 0; y <= ySize; y++)
            {
                for (int x = 0; x <= xSize; x++, i++)
                {
                    tangents[i] = tempTangent;
                }
            }
            mesh.tangents = tangents;


            int[] triangles = new int[xSize * ySize * 6];
            // y: 0 ~ y-1
            for (int ti = 0, vi = 0, y = 0; y < ySize; y++, vi++)
            {
                // x: 0 ~ x-1
                for (int x = 0; x < xSize; x++, ti += 6, vi++)
                {
                    int start = vi + 0;
                    triangles[ti + 0] = start;
                    triangles[ti + 3] = triangles[ti + 2] = start + 1;
                    triangles[ti + 4] = triangles[ti + 1] = xSize + start + 1;
                    triangles[ti + 5] = xSize + start + 2;

                    //mesh.triangles = triangles;
                    //yield return wait;
                }
            }
            mesh.triangles = triangles;
            mesh.RecalculateNormals();

            var render = GetComponent<MeshRenderer>();
            if (render.sharedMaterial && render.sharedMaterial.shader.name == "Pi/CustomTail(Not bExport)")
            {
            }
        }

        private void OnDrawGizmos()
        {
            if (vertices == null)
            {
                return;
            }

            //Gizmos.color = Color.green;

            //for (int i = 0; i < vertices.Length; i++)
            //{
            //    Gizmos.DrawSphere(vertices[i], 0.1f);
            //}
        }
    }
}
