
//----------------------------------------------------------------------------------------------------------
// X-PostProcessing Library
// https://github.com/QianMo/X-PostProcessing-Library
// Copyright (C) 2020 QianMo. All rights reserved.
// Licensed under the MIT License 
// You may not use this file except in compliance with the License.You may obtain a copy of the License at
// http://opensource.org/licenses/MIT
//----------------------------------------------------------------------------------------------------------

using UnityEngine;


namespace XPostProcessing_PI
{

    [ExecuteInEditMode]
    [RequireComponent(typeof(Camera))]
    public class WaveJitter : MonoBehaviour
    {
        public Material shadowMaterial;

        [Range(0f, 50f)]
        [SerializeField]
        public float RGBSplit = 1.0f;

        [Range(0f, 100f)]
        [SerializeField]
        private int Frequency = 16;

        [Range(0f, 1f)]
        [SerializeField]
        public float Speed = 0f;

        [Range(0f, 10f)]
        [SerializeField]
        public int Amount = 1;

        [SerializeField]
        public float Time = 0f;

        [SerializeField]
        public bool IrisAreaActive = false;

        [Range(0f, 2.0f)]
        [SerializeField]
        public float IrisAreaSize = 0.20f;

        [Range(-1f, 1f)]
        [SerializeField]
        public float IrisCenterOffsetX = 0f;

        [Range(-1f, 1f)]
        [SerializeField]
        public float IrisCenterOffsetY = 0f;


        private static string _RGBSplit = "_RGBSplit";
        private static string _Frequency = "_Frequency";
        private static string _Speed = "_Speed";
        private static string _Amount = "_Amount";
        private static string _Progress = "_Progress";
        private static string _CustomTime = "_CustomTime";
        private static string _TexWidth = "_TexWidth";
        private static string _TexHeight = "_TexHeight";

        private static string _IrisAreaActive = "_IrisAreaActive";
        private static string _IrisAreaSize = "_IrisAreaSize";
        private static string _IrisCenterOffsetX = "_IrisCenterOffsetX";
        private static string _IrisCenterOffsetY = "_IrisCenterOffsetY";

        void OnRenderImage(RenderTexture source, RenderTexture destiantion)
        {
            if (shadowMaterial)
            {
                shadowMaterial.SetFloat(_RGBSplit, RGBSplit);
                shadowMaterial.SetInt(_Frequency, Frequency);
                shadowMaterial.SetFloat(_Speed, Speed);
                shadowMaterial.SetInt(_Amount, Amount);
                shadowMaterial.SetFloat(_CustomTime, Time);

                shadowMaterial.SetFloat(_TexWidth, (float)(source.width));
                shadowMaterial.SetFloat(_TexHeight, (float)(source.height));

                shadowMaterial.SetFloat(_IrisAreaSize, IrisAreaSize);
                shadowMaterial.SetInt(_IrisAreaActive, IrisAreaActive ? 1 : 0);
                shadowMaterial.SetFloat(_IrisCenterOffsetX, IrisCenterOffsetX);
                shadowMaterial.SetFloat(_IrisCenterOffsetY, IrisCenterOffsetY);

                Graphics.Blit(source, destiantion, shadowMaterial);
            }

        }
    }

}

