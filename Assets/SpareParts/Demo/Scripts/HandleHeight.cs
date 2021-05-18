using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class HandleHeight : MonoBehaviour
{
	public Slider hightSlider;


	public void Update ( )
	{
		
			var adjustedLocalPosition = transform.localPosition;

			adjustedLocalPosition.y = hightSlider.value;

			transform.localPosition = Vector3.
			Lerp ( transform.localPosition, adjustedLocalPosition,
			Time.smoothDeltaTime );

			transform.localPosition = Vector3.
				MoveTowards ( transform.localPosition, adjustedLocalPosition,
				Time.smoothDeltaTime * Time.smoothDeltaTime );

	}
}
