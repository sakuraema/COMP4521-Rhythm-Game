using UnityEngine;
using UnityEngine.UI;

public class SetTimeScale : MonoBehaviour
{
	public Slider slider;

	private void OnEnable ( )
		=> slider.value = 1f;

	public void Update ( )
		=> Time.timeScale = slider.value;
}
