using System.Collections.Generic;
using System.Text.RegularExpressions;
using UnityEditor;
using UnityEngine;

namespace Assets.X_PostProcessing_Exporter
{
    /// <summary>
    /// XPostProcessing 检查工具
    /// </summary>
    [CanEditMultipleObjects]
    public class XPostProcessingCheckTool : EditorWindow
    {
        public static Regex support_pp_regex = new Regex("(BokehBlur)|(DirectionalBlur)|(GaussianBlur)|(IrisBlurV2)|(RadialBlurV2)");

        [MenuItem("Tools/XPostProcess工具/Check Tool")]
        public static void ShowWindow()
        {
            var window = GetWindow<XPostProcessingCheckTool>();
            window.Show();
        }

        public Vector2 scrollViewPos = Vector2.zero;

        private void OnGUI()
        {
            scrollViewPos = EditorGUILayout.BeginScrollView(scrollViewPos, true, true);

            //uiExplorerXPostProcessing();

            EditorGUILayout.EndScrollView();
        }

        List<Camera> listCamera = new List<Camera>();
        //private void uiExplorerXPostProcessing()
        //{

        //    if (ButtonTool.Button("检查"))
        //    {
        //        listCamera.Clear();

        //        var cameras = GameObject.FindObjectsOfType<Camera>();
        //        var len = cameras.Length;
        //        for (int i = 0; i < len; i++)
        //        {
        //            listCamera.Add(cameras[i]);
        //        }
        //    }

        //    var count = listCamera.Count;
        //    for (int i = 0; i < count; i++)
        //    {
        //        var camera = listCamera[i];
        //        if (camera)
        //        {
        //            ButtonTool.Box(1000, 20);
        //            if (ButtonTool.Button(camera.name))
        //            {
        //                Selection.activeObject = camera.transform;
        //                SceneView.FrameLastActiveSceneView();
        //            }
        //            uiCameraPostProcess(camera);
        //        }
        //    }
        //}

        //private void uiCameraPostProcess(Camera camera)
        //{
        //    var component = camera.GetComponent<PostProcessVolume>();

        //    //BokehBlur _BokehBlur;
        //    //bool hasPostProcess = component.profile.TryGetSettings<BokehBlur>(out _BokehBlur);
        //    //if (hasPostProcess && _BokehBlur.enabled)
        //    //{
        //    //    LabelTool.Label(_BokehBlur.name);
        //    //}

        //    //DirectionalBlur _DirectionalBlur;
        //    //hasPostProcess = component.profile.TryGetSettings<DirectionalBlur>(out _DirectionalBlur);
        //    //if (hasPostProcess && _DirectionalBlur.enabled)
        //    //{
        //    //    LabelTool.Label(_DirectionalBlur.name);
        //    //}

        //    //GaussianBlur _GaussianBlur;
        //    //hasPostProcess = component.profile.TryGetSettings<GaussianBlur>(out _GaussianBlur);
        //    //if (hasPostProcess && _GaussianBlur.enabled)
        //    //{
        //    //    LabelTool.Label(_GaussianBlur.name);
        //    //}

        //    IrisBlurV2 _IrisBlurV2;
        //    bool hasPostProcess = component.profile.TryGetSettings<IrisBlurV2>(out _IrisBlurV2);
        //    if (hasPostProcess && _IrisBlurV2.enabled)
        //    {
        //        LabelTool.Label(_IrisBlurV2.name);

        //        //_IrisBlurV2.BlurRadius.value = Mathf.Abs(Mathf.Cos(Time.time * 0.1f * Mathf.PI)) * 50;
        //    }

        //    //RadialBlurV2 _RadialBlurV2;
        //    //hasPostProcess = component.profile.TryGetSettings<RadialBlurV2>(out _RadialBlurV2);
        //    //if (hasPostProcess && _RadialBlurV2.enabled)
        //    //{
        //    //    LabelTool.Label(_RadialBlurV2.name);
        //    //}

        //    List<PostProcessEffectSettings> listSetting = component.profile.settings;

        //    LabelTool.Label(" 支持的后处理效果 ");
        //    var count = listSetting.Count;
        //    for (int i = 0; i < count; i++)
        //    {
        //        var setting = listSetting[i];

        //        if (support_pp_regex.IsMatch(setting.name))
        //        {
        //            GUILayout.BeginHorizontal();

        //            if (setting.active)
        //            {
        //                if (ButtonTool.Button("取消使用"))
        //                {
        //                    setting.active = false;
        //                    SceneView.RepaintAll();
        //                }
        //            }
        //            else
        //            {
        //                if (ButtonTool.Button("启用"))
        //                {
        //                    setting.active = true;
        //                    SceneView.RepaintAll();
        //                }
        //            }
        //            LabelTool.Label(setting.name);

        //            GUILayout.EndHorizontal();
        //        }
        //    }

        //    LabelTool.Label(">>>>>>>>>>>> 不支持的后处理效果 <<<<<<<<<<<<");
        //    for (int i = 0; i < count; i++)
        //    {
        //        var setting = listSetting[i];

        //        if (!support_pp_regex.IsMatch(setting.name))
        //        {
        //            GUILayout.BeginHorizontal();

        //            if (ButtonTool.Button("取消使用"))
        //            {
        //                setting.active = false;
        //            }
        //            LabelTool.Label(setting.name);

        //            GUILayout.EndHorizontal();
        //        }
        //    }
        //}
    }
}
