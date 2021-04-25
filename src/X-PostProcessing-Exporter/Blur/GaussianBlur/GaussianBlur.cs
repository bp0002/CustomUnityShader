
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
    public class GaussianBlur : MonoBehaviour
    {
        public Material shadowMaterial;

        [Range(0f, 4.0f)]
        [SerializeField]
        public float Delta = 0f;


        [SerializeField]
        protected bool IrisAreaActive = false;

        [Range(0f, 2.0f)]
        [SerializeField]
        public float IrisAreaSize = 0.20f;

        [Range(0f, 4.0f)]
        [SerializeField]
        public float IrisAreaTransition = 0.20f;

        [Range(-1f, 1f)]
        [SerializeField]
        public float IrisCenterOffsetX = 0f;

        [Range(-1f, 1f)]
        [SerializeField]
        public float IrisCenterOffsetY = 0f;

        private static string _DeltaX = "_DeltaX";
        private static string _DeltaY = "_DeltaY";

        private static string _IrisAreaActive = "_IrisAreaActive";
        private static string _IrisAreaSize = "_IrisAreaSize";
        private static string _IrisAreaTransition = "_IrisAreaTransition";
        private static string _IrisCenterOffsetX = "_IrisCenterOffsetX";
        private static string _IrisCenterOffsetY = "_IrisCenterOffsetY";

        private RenderTexture TempTexture;

        void OnRenderImage(RenderTexture source, RenderTexture destiantion)
        {
            if (shadowMaterial)
            {
                if (!TempTexture)
                {
                    TempTexture = new RenderTexture(source.width, source.height, source.depth);
                }

                TempTexture.width = source.width;
                TempTexture.height = source.height;
                TempTexture.depth = source.depth;

                shadowMaterial.SetFloat(_DeltaX, Delta / source.width);
                shadowMaterial.SetFloat(_DeltaY, 0.0f);

                shadowMaterial.SetFloat(_IrisAreaSize, IrisAreaSize);
                shadowMaterial.SetInt(_IrisAreaActive, IrisAreaActive ? 1 : 0);
                shadowMaterial.SetFloat(_IrisCenterOffsetX, IrisCenterOffsetX);
                shadowMaterial.SetFloat(_IrisCenterOffsetY, IrisCenterOffsetY);

                Graphics.Blit(source, TempTexture, shadowMaterial);

                shadowMaterial.SetFloat(_DeltaX, 0.0f);
                shadowMaterial.SetFloat(_DeltaY, Delta / source.height);

                shadowMaterial.SetFloat(_IrisAreaSize, IrisAreaSize);
                shadowMaterial.SetInt(_IrisAreaActive, IrisAreaActive ? 1 : 0);
                shadowMaterial.SetFloat(_IrisCenterOffsetX, IrisCenterOffsetX);
                shadowMaterial.SetFloat(_IrisCenterOffsetY, IrisCenterOffsetY);
                shadowMaterial.SetFloat(_IrisAreaTransition, IrisAreaTransition);

                Graphics.Blit(TempTexture, destiantion, shadowMaterial);
            }

        }
    }

}

