using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

[RequireComponent(typeof(Canvas))]
public class LevelLoadingScreen : MonoBehaviour
{
	public Text loadingText;
	public Slider progressBar;
	public Text percentage;

	protected virtual void Awake()
	{
		GetComponent<Canvas>().enabled = false;
	}
}
