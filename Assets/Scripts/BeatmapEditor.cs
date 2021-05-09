using UnityEngine;
using UnityEditor;
using UnityEditorInternal;

[CustomEditor(typeof(Beatmap))]
public class BeatmapEditor : Editor
{
	private ReorderableList list;
	private SerializedProperty beatsProperty;
	private SerializedProperty bgmProperty;
	private SerializedProperty snapProperty;

	private void OnEnable()
	{
		beatsProperty = serializedObject.FindProperty("beats");
		bgmProperty = serializedObject.FindProperty("BGM");
		snapProperty = serializedObject.FindProperty("snap");

		list = new ReorderableList(serializedObject, beatsProperty);

		list.drawElementCallback = (Rect rect, int index, bool isActive, bool isFocused) =>
		{
			var element = list.serializedProperty.GetArrayElementAtIndex(index);
			var tracks = element.FindPropertyRelative("tracks");
			tracks.arraySize = 4;
			rect.y += 2;
			EditorGUI.PropertyField(new Rect(rect.x, rect.y, 50, EditorGUIUtility.singleLineHeight), element.FindPropertyRelative("type"), GUIContent.none);
			EditorGUI.PropertyField(new Rect(rect.x + 60, rect.y, 30, EditorGUIUtility.singleLineHeight), tracks.GetArrayElementAtIndex(0), GUIContent.none);
			EditorGUI.PropertyField(new Rect(rect.x + 90, rect.y, 30, EditorGUIUtility.singleLineHeight), tracks.GetArrayElementAtIndex(1), GUIContent.none);
			EditorGUI.PropertyField(new Rect(rect.x + 120, rect.y, 30, EditorGUIUtility.singleLineHeight), tracks.GetArrayElementAtIndex(2), GUIContent.none);
			EditorGUI.PropertyField(new Rect(rect.x + 150, rect.y, 30, EditorGUIUtility.singleLineHeight), tracks.GetArrayElementAtIndex(3), GUIContent.none);
			EditorGUI.PropertyField(new Rect(rect.x + rect.width - 60, rect.y, 60, EditorGUIUtility.singleLineHeight), element.FindPropertyRelative("delay"), GUIContent.none);
		};

		list.drawHeaderCallback = (Rect rect) =>
		{
			EditorGUI.LabelField(rect, "Beatmap");
		};

		list.onAddCallback = (ReorderableList l) =>
		{
			var index = l.serializedProperty.arraySize;
			l.serializedProperty.arraySize++;
			l.index = index;

			var element = l.serializedProperty.GetArrayElementAtIndex(index);
			element.FindPropertyRelative("type").enumValueIndex = 0;
			element.FindPropertyRelative("tracks").arraySize = 4;

			for (int i = 0; i < 4; i++)
			{
				SerializedProperty track = element.FindPropertyRelative("tracks").GetArrayElementAtIndex(0);
				track.boolValue = false;
			}

			if (snapProperty.enumValueIndex == 0)
			{
				element.FindPropertyRelative("delay").floatValue = 1 / (bgmProperty.floatValue / 60);
			}
			else if (snapProperty.enumValueIndex == 1)
			{
				element.FindPropertyRelative("delay").floatValue = 1 / (bgmProperty.floatValue / 60) * 0.5f;
			}
			else if (snapProperty.enumValueIndex == 2)
			{
				element.FindPropertyRelative("delay").floatValue = 1 / (bgmProperty.floatValue / 60) * 0.25f;
			}
			else
			{
				element.FindPropertyRelative("delay").floatValue = 1 / (bgmProperty.floatValue / 60) / 3f;
			}
		};
	}

	public override void OnInspectorGUI()
	{
		serializedObject.Update();

		EditorGUILayout.PropertyField(bgmProperty);
		EditorGUILayout.PropertyField(snapProperty);
		EditorGUILayout.Space();
		list.DoLayoutList();

		serializedObject.ApplyModifiedProperties();
	}
}
