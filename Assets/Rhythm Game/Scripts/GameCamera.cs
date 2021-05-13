using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameCamera : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        m_Time = -5.0f;
    }

    // Update is called once per frame
    void Update()
    {
        m_Time += Time.deltaTime;
        if (m_Time > 10.0f)
        {
            GetComponent<Animator>().gameObject.SetActive(true);
        }
    }

    public Animator animator;
    private float m_Time;
}
