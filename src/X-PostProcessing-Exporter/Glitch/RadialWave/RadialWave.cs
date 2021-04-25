
//----------------------------------------------------------------------------------------------------------
// baipeng
//----------------------------------------------------------------------------------------------------------

using UnityEngine;


namespace XPostProcessing_PI
{

    [ExecuteInEditMode]
    [RequireComponent(typeof(Camera))]
    public class RadialWave : MonoBehaviour
    {
        public Material shadowMaterial;

        [SerializeField]
        public bool AsCircle = false;

        [Range(0f, 8.0f)]
        [SerializeField]
        public float WaveStartRadial = 0.0f;

        [Range(0f, 8.0f)]
        [SerializeField]
        public float WaveEndRadial = 0.0f;

        [Range(0f, 10.0f)]
        [SerializeField]
        public float WaveWidth = 1.0f;

        [Range(0f, 64.0f)]
        [SerializeField]
        private float WaveCount = 1.0f;

        [Range(0f, 40f)]
        [SerializeField]
        public float BlurRadius = 1.0f;

        //[SerializeField]
        private int Iteration = 16;

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


        private static string _WaveStartRadial = "_WaveStartRadial";
        private static string _WaveEndRadial = "_WaveEndRadial";
        private static string _WaveWidth = "_WaveWidth";
        private static string _WaveCount = "_WaveCount";
        private static string _WaveScreenWidth = "_WaveScreenWidth";
        private static string _WaveScreenHeight = "_WaveScreenHeight";

        private static string _BlurRadius = "_BlurRadius";
        private static string _Iteration = "_Iteration";

        private static string _IrisAreaActive = "_IrisAreaActive";
        private static string _IrisAreaSize = "_IrisAreaSize";
        private static string _IrisCenterOffsetX = "_IrisCenterOffsetX";
        private static string _IrisCenterOffsetY = "_IrisCenterOffsetY";


        void OnRenderImage(RenderTexture source, RenderTexture destiantion)
        {
            if (shadowMaterial)
            {
                shadowMaterial.SetFloat(_WaveStartRadial, WaveStartRadial);
                shadowMaterial.SetFloat(_WaveEndRadial, WaveEndRadial);
                shadowMaterial.SetFloat(_WaveWidth, WaveWidth);
                shadowMaterial.SetFloat(_WaveCount, WaveCount);

                shadowMaterial.SetFloat(_WaveScreenWidth, AsCircle ? source.width : 1.0f);
                shadowMaterial.SetFloat(_WaveScreenHeight, AsCircle ? source.height : 1.0f);

                shadowMaterial.SetFloat(_BlurRadius, BlurRadius / source.width);
                shadowMaterial.SetInt(_Iteration, Iteration);

                shadowMaterial.SetFloat(_IrisAreaSize, IrisAreaSize);
                shadowMaterial.SetInt(_IrisAreaActive, IrisAreaActive ? 1 : 0);
                shadowMaterial.SetFloat(_IrisCenterOffsetX, IrisCenterOffsetX);
                shadowMaterial.SetFloat(_IrisCenterOffsetY, IrisCenterOffsetY);

                Graphics.Blit(source, destiantion, shadowMaterial);
            }

        }
    }

}

