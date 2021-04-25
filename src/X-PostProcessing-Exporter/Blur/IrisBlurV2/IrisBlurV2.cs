
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
    public class IrisBlurV2 : MonoBehaviour
    {
        public Material shadowMaterial;

        [Range(0f, 40f)]
        [SerializeField]
        public float BlurRadius = 1.0f;

        //[SerializeField]
        private int Iteration = 16;

        [SerializeField]
        public bool IrisAreaActive = false;

        [Range(0f, 4.0f)]
        [SerializeField]
        public float IrisAreaTransition = 0.20f;

        [Range(0f, 2.0f)]
        [SerializeField]
        public float IrisAreaSize = 0.20f;

        [Range(-1f, 1f)]
        [SerializeField]
        public float IrisCenterOffsetX = 0f;

        [Range(-1f, 1f)]
        [SerializeField]
        public float IrisCenterOffsetY = 0f;


        private static string _BlurRadius = "_BlurRadius";
        private static string _Iteration = "_Iteration";

        private static string _IrisAreaActive = "_IrisAreaActive";
        private static string _IrisAreaSize = "_IrisAreaSize";
        private static string _IrisAreaTransition = "_IrisAreaTransition";
        private static string _IrisCenterOffsetX = "_IrisCenterOffsetX";
        private static string _IrisCenterOffsetY = "_IrisCenterOffsetY";


        void OnRenderImage(RenderTexture source, RenderTexture destiantion)
        {
            if (shadowMaterial)
            {
                shadowMaterial.SetFloat(_BlurRadius, BlurRadius / source.width);
                shadowMaterial.SetInt(_Iteration, Iteration);

                shadowMaterial.SetFloat(_IrisAreaSize, IrisAreaSize);
                shadowMaterial.SetInt(_IrisAreaActive, IrisAreaActive ? 1 : 0);
                shadowMaterial.SetFloat(_IrisCenterOffsetX, IrisCenterOffsetX);
                shadowMaterial.SetFloat(_IrisCenterOffsetY, IrisCenterOffsetY);
                shadowMaterial.SetFloat(_IrisAreaTransition, IrisAreaTransition);

                Graphics.Blit(source, destiantion, shadowMaterial);
            }

        }
    }

}

