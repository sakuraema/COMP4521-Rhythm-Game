using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ScreenTouch : MonoBehaviour
{
    // Update is called once per frame
    void Update()
    {
        //foreach (Touch touch in Input.touches)
        //{
        //    if (touch.phase == TouchPhase.Began)
        //    {
        //        // Construct a ray from the current touch coordinates
        //        Ray ray = Camera.main.ScreenPointToRay(touch.position);
        //        if (Physics.Raycast(ray))
        //        {
        //            // Create a particle if hit
        //            Instantiate(touchEffect, transform.position, transform.rotation);
        //        }
        //    }
        //}

        if (Input.GetMouseButton(0))
        {
            RaycastHit2D hit = Physics2D.Raycast(Camera.main.ScreenToWorldPoint(Input.mousePosition), Vector2.zero);

            m_touchPosition = Camera.main.ScreenToWorldPoint(Input.mousePosition);
            m_touchPosition.z = transform.position.z;

            GameObject clone = Instantiate(touchEffect, m_touchPosition, Quaternion.identity);
            Destroy(clone, 0.2f);
        }
    }

    public GameObject touchEffect;
    private Vector3 m_touchPosition;
}
