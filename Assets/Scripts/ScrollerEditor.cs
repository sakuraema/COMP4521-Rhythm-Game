using UnityEngine;
using UnityEditor;
using UnityEditorInternal;

[CustomEditor(typeof(Scroller))]
public class ScrollerEditor : Editor
{
	//private ReorderableList list;

	//private void OnEnable()
	//{
	//	list = new ReorderableList(serializedObject,
	//			serializedObject.FindProperty("beats"),
	//			true, true, true, true);
	//}

	//public override void OnInspectorGUI()
	//{
	//	serializedObject.Update();
	//	list.DoLayoutList();
	//	serializedObject.ApplyModifiedProperties();
	//}
}