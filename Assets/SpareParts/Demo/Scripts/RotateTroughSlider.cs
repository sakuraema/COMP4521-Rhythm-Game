using UnityEngine;
using UnityEngine.UI;

public class RotateTroughSlider : MonoBehaviour
{
	public Slider slider;
	
	public Vector3 minRotation;
	public Vector3 maxRotation;

	public bool normalized = false;

	private Vector3 eulerRotation;
	private Quaternion rotation;
	private Vector3 targetRotation;
	public float rotationSpeed = 180f;

	private float currentSliderValue;
	private float previousSliderValue;
	private float rotationDirection;

	private void Update ( )
	{
		currentSliderValue = slider.value;
		var smoothing =  (Time.smoothDeltaTime * Time.smoothDeltaTime) * rotationSpeed;


		if ( previousSliderValue != currentSliderValue )
		{
			rotationDirection = currentSliderValue > previousSliderValue ? 1 : -1;
			previousSliderValue = currentSliderValue;
		}
		else
		{
			rotationDirection = Mathf.Lerp (rotationDirection , 0f, smoothing );
			rotationDirection = Mathf.MoveTowards (rotationDirection , 0f, smoothing );
		}

		eulerRotation = transform.localEulerAngles;
		rotation = transform.rotation;

		if ( normalized )
		{
			targetRotation.x = Mathf.Lerp ( minRotation.x, maxRotation.x, currentSliderValue );
			targetRotation.y = Mathf.Lerp ( minRotation.y, maxRotation.y, currentSliderValue );
			targetRotation.z = Mathf.Lerp ( minRotation.z, maxRotation.z, currentSliderValue );
		}
		else
		{
			targetRotation.y = currentSliderValue;
		}

		//transform.localEulerAngles = targetRotation;
		transform.rotation = Quaternion.Lerp ( transform.rotation, Quaternion.Euler( targetRotation), smoothing);
		transform.rotation = Quaternion.RotateTowards( transform.rotation, Quaternion.Euler( targetRotation), smoothing);
	}
}
