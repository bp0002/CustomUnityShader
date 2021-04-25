using UnityEditor;
using UnityEngine;

namespace Assets.X_PostProcessing_Exporter
{
    /// <summary>
    /// XPostProcessing 导出工具
    /// </summary>
    [CanEditMultipleObjects]
    public class XPostProcessExport : EditorWindow
    {
        [MenuItem("Tools/XPostProcess工具/Export Tool")]
        public static void ShowWindow()
        {
            var window = GetWindow<XPostProcessExport>();
            window.Show();
        }

        public Vector2 scrollViewPos = Vector2.zero;

        private void OnGUI()
        {
            scrollViewPos = EditorGUILayout.BeginScrollView(scrollViewPos, true, true);

            uiExportXPostProcessing();

            EditorGUILayout.EndScrollView();
        }

        private void uiExportXPostProcessing()
        {
            GUILayout.TextArea("SDDSDSDADAD{DFDF:D}");
        }
    }
}
